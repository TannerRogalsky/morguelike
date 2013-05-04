local Main = Game:addState('Main')

function Main:enteredState()
  -- self.map = Map:new(0, 0, 30, 25, 25, 25)
  local loaded_map = table.load("test_map")
  self.map = Map:new(loaded_map.x, loaded_map.y, loaded_map.width, loaded_map.height, loaded_map.tile_width, loaded_map.tile_height)

  -- populate sibling data
  for x,y,tile in self.map.grid:each() do
    tile.siblings = {}
    for direction_data,sibling_data in pairs(loaded_map.grid[x][y].siblings) do
      tile.siblings[Direction[direction_data.x][direction_data.y]] = self.map.grid:g(sibling_data.x, sibling_data.y)
    end
  end

  -- load the entities
  for index,entity_data in ipairs(loaded_map.entity_list) do
    local entity_type = _G[entity_data.class.name]
    local entity = entity_type:new(self.map, entity_data.x, entity_data.y, entity_data.width, entity_data.height, entity_data.z)
    self.map:add_entity(entity)

    if instanceOf(Player, entity) then
      self.map.player = entity
    end
  end
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

function Main:quit()
end

return Main
