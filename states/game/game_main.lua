local Main = Game:addState('Main')

function Main:enteredState(map_to_load)
  local loaded_map = table.load("levels/" .. map_to_load)
  local x = (g.getWidth() / 2) - (loaded_map.width * loaded_map.tile_width / 2)
  local y = (g.getHeight() / 2) - (loaded_map.height * loaded_map.tile_height / 2)
  self.map = Map:new(x, y, loaded_map.width, loaded_map.height, loaded_map.tile_width, loaded_map.tile_height)

  -- populate sibling data
  for x,y,tile in self.map.grid:each() do
    tile.siblings = {}
    for direction_data,sibling_data in pairs(loaded_map.grid[x][y].siblings) do
      local sibling = self.map.grid:g(sibling_data.x, sibling_data.y)
      tile.siblings[Direction[direction_data.x][direction_data.y]] = sibling
      tile.secondary_directions[sibling] = Direction[direction_data.x][direction_data.y]
    end

    if loaded_map.grid[x][y].secondary_directions then
      tile.secondary_directions = {}
      for sibling_data,direction_data in pairs(loaded_map.grid[x][y].secondary_directions) do
        local sibling = self.map.grid:g(sibling_data.x, sibling_data.y)
        tile.secondary_directions[sibling] = Direction[direction_data.x][direction_data.y]
      end
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
  self.map:update(dt)
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

  if key == "backspace" then
    self:gotoState("Menu")
  end
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
