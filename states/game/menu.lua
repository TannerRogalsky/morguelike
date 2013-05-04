local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.maps = love.filesystem.enumerate("levels")
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.print("Menu", 100, 100)
  g.print("e for editor", 100, 120)
  g.print("p for play", 100, 140)

  local x, y = 400, 100
  for index,map in ipairs(self.maps) do
    g.print(index .. ". " .. map, x, y + (20 * index))
  end
end

function Menu:keypressed(key, unicode)
  local number_key = tonumber(key)
  if self.maps[number_key] then
    self:gotoState("Editor", self.maps[number_key])
  end

  if key == "e" then
    self:gotoState("Editor")
  elseif key == "p" then
    self:gotoState("Main")
  end
end

function Menu:exitedState()
  self.maps = nil
end

return Menu
