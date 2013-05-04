Player = class('Player', MapEntity)

function Player:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.z = 3
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

  if can_move then
    self.x, self.y = new_tile.x, new_tile.y
  end

  self:insert_into_grid()
  return can_move
end

Player.__lt = MapEntity.__lt
Player.__le = MapEntity.__le
