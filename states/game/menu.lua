local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.maps = love.filesystem.enumerate("levels")
  table.insert(self.maps, "make new map")
  self.active_map_index = #self.maps
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.print("Menu", 100, 100)
  g.print("e for editor", 100, 120)
  g.print("p for play", 100, 140)

  local x, y = 400, 100
  for index,map in ipairs(self.maps) do
    g.setColor(COLORS.white:rgb())
    if self.maps[self.active_map_index] == map then
      g.setColor(COLORS.red:rgb())
    end
    g.print(index .. ". " .. map, x, y + (20 * index))
  end
end

function Menu:keypressed(key, unicode)
  local number_key = tonumber(key)
  if self.maps[number_key] then
    self.active_map_index = number_key
  end

  if key == "up" then
    self.active_map_index = self.active_map_index - 1
  elseif key == "down" then
    self.active_map_index = self.active_map_index + 1
  end

  if key == "e" then
    self:gotoState("Editor", self.maps[self.active_map_index])
  elseif key == "p" and self.maps[self.active_map_index] ~= "make new map" then
    self:gotoState("Main", self.maps[self.active_map_index])
  end
end

function Menu:exitedState()
  self.maps = nil
end

return Menu
