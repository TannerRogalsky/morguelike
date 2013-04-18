MapTile = class('MapTile', Base)

function MapTile:initialize(parent, x, y)
  Base.initialize(self)
  self.x = x
  self.y = y

  self.color = COLORS.green
end

function MapTile:update(dt)
end

function MapTile:render(x, y)
  g.setColor(self.color:rgb())
  g.rectangle("fill", x, y, 10, 10)
  g.setColor(COLORS.black:rgb())
  g.rectangle("line", x, y, 10, 10)
end

function MapTile:mousepressed(x, y, button)
end

function MapTile:mousereleased(x, y, button)
end

function MapTile:keypressed(key, unicode)
end

function MapTile:keyreleased(key, unicode)
end

function MapTile:joystickpressed(joystick, button)
  print(joystick, button)
end

function MapTile:joystickreleased(joystick, button)
  print(joystick, button)
end

function MapTile:focus(has_focus)
end

function MapTile:quit()
end
