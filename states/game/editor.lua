local Editor = Game:addState('Editor')

function Editor:enteredState()
  self.map = Map:new(0, 0, 20, 20, 32, 32)

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
    self:gotoState("Main")
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
  table.save(to_save, "test_map")

  self.map = nil
end

return Editor
