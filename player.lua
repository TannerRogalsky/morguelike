Player = class('Player', MapEntity)

function Player:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.z = 3

  self.out_pos, self.in_pos = {}, {}
  self.tween_out, self.tween_in = nil, nil
end

function Player:update(dt)
end

function Player:render()
  g.setColor(COLORS.blue:rgb())
  if self.tween_out and self.tween_in then

    local x, y = self.parent:grid_to_world_coords(self.old_tile.x, self.old_tile.y)
    g.setScissor(x, y, self.parent.tile_width, self.parent.tile_height)
    g.rectangle("fill", self.out_pos.x, self.out_pos.y, self.parent.tile_width, self.parent.tile_height)

    x, y = self.parent:grid_to_world_coords(self.new_tile.x, self.new_tile.y)
    g.setScissor(x, y, self.parent.tile_width, self.parent.tile_height)
    g.rectangle("fill", self.in_pos.x, self.in_pos.y, self.parent.tile_width, self.parent.tile_height)

    g.setScissor()
  else
    local x, y = self.parent:grid_to_world_coords(self.x, self.y)
    g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  end
end

function Player:move(delta_x, delta_y)
  self:remove_from_grid()
  local current_tile = self.parent.grid:g(self.x, self.y)
  local dir = Direction[delta_x][delta_y]
  local new_tile = current_tile.siblings[dir]

  -- successful move
  local can_move = false
  for id,entity in pairs(new_tile.content) do
    if instanceOf(Floor, entity) then
      can_move = true
    elseif instanceOf(Block, entity) then
      local block_can_move = entity:move(delta_x, delta_y)
      can_move = block_can_move

      if can_move == false then
        break
      end
    end
  end

  -- we're already tweening. don't move again
  if self.tween_out and self.tween_in then
    can_move = false
  end

  if can_move then
    self.new_tile, self.old_tile = new_tile, current_tile
    self.x, self.y = new_tile.x, new_tile.y

    local tween_speed = 0.2

    self.out_pos = {}
    self.out_pos.x, self.out_pos.y = self.parent:grid_to_world_coords(self.old_tile.x, self.old_tile.y)
    local target_out = {}
    target_out.x, target_out.y = self.parent:grid_to_world_coords(self.old_tile.x + delta_x, self.old_tile.y + delta_y)
    self.tween_out = tween(tween_speed, self.out_pos, target_out, "linear", function() self.tween_out = nil end)

    self.in_pos = {}
    self.in_pos.x, self.in_pos.y = self.parent:grid_to_world_coords(self.new_tile.x - delta_x, self.new_tile.y - delta_y)
    local target_in = {}
    target_in.x, target_in.y = self.parent:grid_to_world_coords(self.new_tile.x, self.new_tile.y)
    self.tween_in = tween(tween_speed, self.in_pos, target_in, "linear", function() self.tween_in = nil end)
  end

  self:insert_into_grid()
  return can_move
end

Player.__lt = MapEntity.__lt
Player.__le = MapEntity.__le
