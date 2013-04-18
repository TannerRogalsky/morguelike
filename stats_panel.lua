StatsPanel = class('StatsPanel', Base):include(Stateful)

function StatsPanel:initialize()
  Base.initialize(self)

  self.canvas = g.newCanvas(g.getWidth() / 4, g.getHeight())
end

function StatsPanel:update(dt)
end

function StatsPanel:render()
  g.setCanvas(self.canvas)
  g.setColor(COLORS.green:rgb())
  g.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())
  g.setColor(COLORS.white:rgb())
  local x, y = game.camera:mousePosition()
  g.print(x .. " " .. y, 100, 100)
  g.setCanvas()

  g.draw(self.canvas, g.getWidth() / 4 * 3, 0)
end

function StatsPanel:mousepressed(x, y, button)
end

function StatsPanel:mousereleased(x, y, button)
end

function StatsPanel:keypressed(key, unicode)
end

function StatsPanel:keyreleased(key, unicode)
end

function StatsPanel:joystickpressed(joystick, button)
  print(joystick, button)
end

function StatsPanel:joystickreleased(joystick, button)
  print(joystick, button)
end

function StatsPanel:focus(has_focus)
end

function StatsPanel:quit()
end
