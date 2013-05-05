local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.maps = love.filesystem.enumerate("levels")
  self.active_map_index = 1
  self.background = self.preloaded_image["menu.jpg"]

  love.audio.stop(mainmusic)
  love.audio.play(menumusic)
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background, 0, 0)
end

function Menu:keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  else
    self:gotoState("Main", self.maps[self.active_map_index])
  end
end

function Menu:exitedState()
end

return Menu
