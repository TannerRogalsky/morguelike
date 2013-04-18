local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = Grid:new(30, 30)
  self.grid:s(2, 2, {})
  function self.grid:render()
    for x, y, value in self:each() do
      if value == nil then
        g.setColor(COLORS.red:rgb())
      else
        g.setColor(COLORS.green:rgb())
      end
      g.rectangle("fill", 10 * x, y * 10, 10, 10)
      g.setColor(COLORS.black:rgb())
      g.rectangle("line", 10 * x, y * 10, 10, 10)
    end
  end
end

function Main:update(dt)
end

function Main:render()
  self.camera:set()

  self.grid:render()

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
