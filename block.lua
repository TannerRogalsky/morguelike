Block = class('Block', MapEntity)

function Block:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.z = 3
end

function Block:render()
  self.parent:each(function(tile)
    g.setColor(COLORS.red:rgb())
    local x, y = self.parent:grid_to_world_coords(tile.x, tile.y)
    g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  end, self.x, self.y, self.width, self.height)
end

function Block:move(delta_x, delta_y)
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
      can_move = false
      break
    elseif instanceOf(Target, entity) then
      print("YOU JUST WON. YOU JUST WON THE GAME. YOU JUST WON. YOU JUST WON THE GAME.")
    end
  end

  if can_move then
    self.x, self.y = new_tile.x, new_tile.y
  end

  self:insert_into_grid()
  return can_move
end

Block.__lt = MapEntity.__lt
Block.__le = MapEntity.__le
