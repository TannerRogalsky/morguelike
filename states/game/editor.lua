local Editor = Game:addState('Editor')

function Editor:enteredState(map_to_load)
  if map_to_load ~= "make new map" then
    local loaded_map = table.load("levels/" .. map_to_load)
    self.map_name = map_to_load
    self.map = Map:new(loaded_map.x, loaded_map.y, loaded_map.width, loaded_map.height, loaded_map.tile_width, loaded_map.tile_height)

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
  else
    self.map = Map:new(0, 0, 14, 14, 50, 50)
  end

  self.types = {Player, Floor, Block, Target, {name = "siblings"}}
  self.active_type_index = 1
  self.active_direction = Direction.NORTH
  self.active_secondary_direction = Direction.NORTH

  self.delete_mode = false

  self.stats = StatsPanel:new(self)
end

function Editor:render()
  self.map:render()
  self.stats:render()

  local next = next

  g.setColor(COLORS.lightblue:rgb())
  for _,_,tile in self.map.grid:each() do
    if next(tile.content) then
      for direction,neighbor in pairs(tile.siblings) do
        if next(neighbor.content) then
          local offset_x, offset_y = self.map.tile_width / 2, self.map.tile_width / 2
          local tile_x, tile_y = self.map:grid_to_world_coords(tile.x, tile.y)
          local neighbor_x, neighbor_y = self.map:grid_to_world_coords(neighbor.x, neighbor.y)

          g.line(tile_x + offset_x, tile_y + offset_y, neighbor_x + offset_x, neighbor_y + offset_y)
        end
      end
    end
  end

  if self.mousedown_pos then
    g.setColor(COLORS.blue:rgb())
    g.line(self.mousedown_pos.x, self.mousedown_pos.y, love.mouse.getPosition())
  end
end

function Editor:update(dt)

end

function Editor:mousepressed(x, y, button)
  if self.delete_mode then
    local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
    self:clear(grid_x, grid_y)
  else
    if self.types[self.active_type_index].name == "siblings" then
      self.mousedown_pos = {}
      self.mousedown_pos.x, self.mousedown_pos.y = love.mouse.getPosition()
    else
      local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
      local new_entity = self.types[self.active_type_index]:new(self.map, grid_x, grid_y)
      self.map:add_entity(new_entity)
    end
  end
end

function Editor:mousereleased(x, y, button)
  if self.mousedown_pos then
    local end_tile = self.map.grid:g(self.map:world_to_grid_coords(x, y))
    local start_tile = self.map.grid:g(self.map:world_to_grid_coords(self.mousedown_pos.x, self.mousedown_pos.y))
    start_tile.siblings[self.active_direction] = end_tile
    start_tile.secondary_directions[end_tile] = self.active_secondary_direction

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
  end,
  up = function(self)
    self.active_secondary_direction = Direction.NORTH
  end,
  down = function(self)
    self.active_secondary_direction = Direction.SOUTH
  end,
  right = function(self)
    self.active_secondary_direction = Direction.EAST
  end,
  left = function(self)
    self.active_secondary_direction = Direction.WEST
  end,
  delete = function(self)
    self.delete_mode = not self.delete_mode
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

function Editor:clear(x, y)
  local tile = self.map.grid:g(x, y)
  for id,entity in pairs(tile.content) do
    self.map:remove_entity(entity)
  end
  tile.content = {}
  for _,_,neighbor in self.map.grid:each(tile.x - 1, tile.y - 1, 3, 3) do
    local dir_x, dir_y = neighbor.x - tile.x, neighbor.y - tile.y
    local direction = Direction[dir_x][dir_y]

    if direction then
      tile.siblings[direction] = neighbor
    end
  end
end

function Editor:keyreleased(key, unicode)
end

function Editor:exitedState()
  local to_save = self.map
  if self.map_name then
    table.save(to_save, "levels/" .. self.map_name)
  else
    table.save(to_save, "levels/map" .. #love.filesystem.enumerate("levels"))
  end

  self.map_name = nil
  self.map = nil
end

return Editor
