StatsPanel = class('StatsPanel', Base):include(Stateful)

function StatsPanel:initialize(parent)
  Base.initialize(self)
  self.parent = parent

  self.canvas = g.newCanvas(g.getWidth() / 4, g.getHeight())
end

function StatsPanel:update(dt)
end

function StatsPanel:render()
  g.setCanvas(self.canvas)
  g.setColor(COLORS.green:rgb())
  g.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())
  g.setColor(COLORS.white:rgb())
  -- local x, y = game.camera:mousePosition()
  -- g.print(x .. " " .. y, 100, 100)

  g.print(self.parent.types[self.parent.active_type_index].name, 0, 0)
  g.print("primary: " .. self.parent.active_direction:cardinal_name(), 0, 20)
  g.print("secondary: " .. self.parent.active_secondary_direction:cardinal_name(), 150, 20)

  if self.parent.delete_mode then
    g.print("DELETE MODE ON", 0, 40, 0, 2)
  end

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
