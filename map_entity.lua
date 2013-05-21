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

  self.props = {}
end

function MapEntity:update(dt)
end

function MapEntity:insert_into_grid()
  self.parent:each(function(tile)
      tile.content[self.id] = self
  end, self.x, self.y, self.width, self.height)
end

function MapEntity:remove_from_grid()
  self.parent:each(function(tile)
      tile.content[self.id] = nil
  end, self.x, self.y, self.width, self.height)
end

function MapEntity:move(delta_x, delta_y)
  self:remove_from_grid()
  self.x, self.y = self.x + delta_x, self.y + delta_y
  self:insert_into_grid()
end

function MapEntity:quit()
end
