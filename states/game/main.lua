local Main = Game:addState('Main')

function Main:enteredState()
  self.map = Map:new(0, 0, 45, 30, 15, 15)
end

function Main:update(dt)
end

function Main:render()
  self.camera:set()

  self.map:render()

  -- g.setColor(COLORS.white:rgb())
  -- g.print("test", 100, 100)

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  self.map:keypressed(key, unicode)
end

function Main:keyreleased(key, unicode)
  self.map:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
end

return Main
