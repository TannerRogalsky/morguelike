local Main = Game:addState('Main')

function Main:enteredState()
  self.map = Map:new()

end

function Main:update(dt)
end

function Main:render()
  self.camera:set()

  self.map:render()

  g.setColor(COLORS.white:rgb())
  g.print("test", 100, 100)

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  self.camera:setScale(0.5, 0.5)
end

function Main:keyreleased(key, unicode)
  self.camera:setScale(1, 1)
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
