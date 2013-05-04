local Editor = Game:addState('Editor')

function Editor:enteredState()
  self.map = Map:new(0, 0, 20, 20, 32, 32)
end

function Editor:render()
  self.map:render()
end

function Editor:update(dt)

end

function Editor:mousepressed(x, y, button)
  local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
  print(grid_x, grid_y)
  local new_entity = MapEntity:new(self.map, grid_x, grid_y)
  self.map:add_entity(new_entity)
end

function Editor:mousereleased(x, y, button)
end

function Editor:keypressed(key, unicode)
end

function Editor:keyreleased(key, unicode)
end

function Editor:exitedState()

end

return Editor
