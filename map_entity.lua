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
  if self.image then
  else
    for offset_x= 0, self.width - 1 do
      for offset_y = 0, self.height - 1 do
        g.setColor(COLORS.yellow:rgb())
        local x, y = self.parent:grid_to_world_coords(self.x + offset_x, self.y + offset_y)
        g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
      end
    end
  end
end

function MapEntity:insert_into_grid()
  local origin_tile =  self.parent.grid:g(self.x, self.y)
  local tile, grid = origin_tile, self.parent.grid

  tile.content[self.id] = self
  -- print(tile)


  local dir_x, dir_y = 0, 0
  for offset_x = 1, self.width do
    for offset_y = 1, self.height - 1 do
      dir_x, dir_y = 0, 1

      tile = tile.siblings[Direction[dir_x][dir_y]]
      tile.content[self.id] = self
      -- print(tile)
    end

    if offset_x < self.width then
      dir_x, dir_y = 1, 0

      tile = origin_tile.siblings[Direction[dir_x][dir_y]]
      origin_tile = tile
      tile.content[self.id] = self
      -- print(tile)
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
