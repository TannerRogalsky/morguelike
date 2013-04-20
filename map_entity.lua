MapEntity = class('MapEntity', Base):include(Stateful)

function MapEntity:initialize(parent, x, y, width, height, z)
  Base.initialize(self)
  assert(instanceOf(Map, parent))
  assert(is_num(x) and is_num(y))
  assert(is_num(width) or width == nil)
  assert(is_num(height) or height == nil)
  assert(is_num(z) or z == nil)

  self.parent = parent
  self.x, self.y = x, y
  self.width, self.height = width or 1, height or 1
  self.z = z or 1
end

function MapEntity:update(dt)
end

function MapEntity:render()
  g.setColor(COLORS.yellow:rgb())
  local x, y = self.parent:grid_to_world_coords(self.x, self.y)
  local width = self.width * self.parent.tile_width
  local height = self.height * self.parent.tile_height
  g.rectangle("fill", x, y, width, height)
end

function MapEntity:insert_into_grid()
  for offset_x= 0, self.width - 1 do
    for offset_y = 0, self.height - 1 do
      local tile = self.parent.grid:g(self.x + offset_x, self.y + offset_y)
      tile.content[self.id] = self
    end
  end
end

function MapEntity:remove_from_grid()
  for offset_x= 0, self.width - 1 do
    for offset_y = 0, self.height - 1 do
      local tile = self.parent.grid:g(self.x + offset_x, self.y + offset_y)
      tile.content[self.id] = nil
    end
  end
end

function MapEntity:move(delta_x, delta_y)
  self:remove_from_grid()
  self.x, self.y = self.x + delta_x, self.y + delta_y
  self:insert_into_grid()
end

function MapEntity:__lt(other)
  if self.z < other.z then return true
  elseif self.z == other.z and self.id < other.id then return true
  else return false
  end
end

function MapEntity:__le(other)
  return self < other
end

function MapEntity:quit()
end
