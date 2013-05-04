Player = class('Player', MapEntity)

function Player:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)
end

function Player:move(delta_x, delta_y)
  self:remove_from_grid()
  local current_tile = self.parent.grid:g(self.x, self.y)
  local dir = Direction[delta_x][delta_y]
  local new_tile = current_tile.siblings[dir]
  self.x, self.y = new_tile.x, new_tile.y
  self:insert_into_grid()
end
