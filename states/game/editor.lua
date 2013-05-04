local Editor = Game:addState('Editor')

function Editor:enteredState(map_to_load)
  if map_to_load then
    local loaded_map = table.load("levels/" .. map_to_load)
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
  else
    self.map = Map:new(0, 0, 14, 14, 50, 50)
  end

  self.types = {Player, Floor, Block, Target, {name = "siblings"}}
  self.active_type_index = 1
  self.active_direction = Direction.NORTH

  self.stats = StatsPanel:new(self)
end

function Editor:render()
  self.map:render()
  self.stats:render()

  if self.mousedown_pos then
    g.setColor(COLORS.blue:rgb())
    g.line(self.mousedown_pos.x, self.mousedown_pos.y, love.mouse.getPosition())
  end
end

function Editor:update(dt)

end

function Editor:mousepressed(x, y, button)
  if self.types[self.active_type_index].name == "siblings" then
    self.mousedown_pos = {}
    self.mousedown_pos.x, self.mousedown_pos.y = love.mouse.getPosition()
  else
    local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
    print(grid_x, grid_y)
    local new_entity = self.types[self.active_type_index]:new(self.map, grid_x, grid_y)
    self.map:add_entity(new_entity)
  end
end

function Editor:mousereleased(x, y, button)
  if self.types[self.active_type_index].name == "siblings" then
    local end_tile = self.map.grid:g(self.map:world_to_grid_coords(x, y))
    local start_tile = self.map.grid:g(self.map:world_to_grid_coords(self.mousedown_pos.x, self.mousedown_pos.y))
    print(start_tile, end_tile)
    start_tile.siblings[self.active_direction] = end_tile

    self.mousedown_pos = nil
  end
end

local key_control_map = {
  backspace = function(self)
    self:gotoState("Menu")
  end,
  w = function(self)
    self.active_direction = Direction.NORTH
  end,
  s = function(self)
    self.active_direction = Direction.SOUTH
  end,
  d = function(self)
    self.active_direction = Direction.EAST
  end,
  a = function(self)
    self.active_direction = Direction.WEST
  end
}

function Editor:keypressed(key, unicode)
  self.stats:keypressed(key, unicode)

  local num_pressed = tonumber(key)
  if num_pressed and self.types[num_pressed] then
    self.active_type_index = num_pressed
  end

  local action = key_control_map[key]
  if is_func(action) then action(self) end
end

function Editor:keyreleased(key, unicode)
end

function Editor:exitedState()
  local to_save = self.map
  table.save(to_save, "levels/test_map")

  self.map = nil
end

return Editor
