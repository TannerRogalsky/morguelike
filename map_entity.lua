MapEntity = class('MapEntity', Base):include(Stateful)

function MapEntity:initialize(parent, x, y, width, height)
  Base.initialize(self)
  self.parent = parent
  self.x, self.y = x, y
end

function MapEntity:update(dt)
end

function MapEntity:render(x, y)
  g.setColor(COLORS.yellow:rgb())
  g.rectangle("fill", x, y, 10, 10)
end

function MapEntity:move(delta_x, delta_y)
  local current_tile = self.parent.grid:g(self.x, self.y)
  local target_tile = self.parent.grid:g(self.x + delta_x, self.y + delta_y)
  current_tile.content[self.id] = nil
  target_tile.content[self.id] = self
  self.x, self.y = self.x + delta_x, self.y + delta_y
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
