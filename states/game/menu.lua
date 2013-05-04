local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.print("Menu", 100, 100)
  g.print("e for editor", 100, 120)
  g.print("p for play", 100, 140)
end

function Menu:keypressed(key, unicode)
  if key == "e" then
    self:gotoState("Editor")
  elseif key == "p" then
    self:gotoState("Main")
  end
end

function Menu:exitedState()
end

return Menu
