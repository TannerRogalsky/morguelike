MapEntity = class('MapEntity', Base):include(Stateful)

function MapEntity:initialize(parent, x, y, width, height)
  Base.initialize(self)
  assert(instanceOf(Map, parent))
  assert(is_num(x) and is_num(y))
  assert(is_num(width) or width == nil)
  assert(is_num(height) or height == nil)

  self.parent = parent
  self.x, self.y = x, y
  self.width, self.height = width or 1, height or 1
end

function MapEntity:update(dt)
end

function MapEntity:render(x, y)
  g.setColor(COLORS.yellow:rgb())
  g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
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

function MapEntity:mousepressed(x, y, button)
end

function MapEntity:mousereleased(x, y, button)
end

function MapEntity:keypressed(key, unicode)
end

function MapEntity:keyreleased(key, unicode)
end

function MapEntity:joystickpressed(joystick, button)
  print(joystick, button)
end

function MapEntity:joystickreleased(joystick, button)
  print(joystick, button)
end

function MapEntity:focus(has_focus)
end

function MapEntity:quit()
end
