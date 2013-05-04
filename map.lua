Map = class('Map', Base)
Map.render_queue_depth = 3 -- this is just a best guess of how much map entities overlap

function Map:initialize(x, y, width, height, tile_width, tile_height)
  Base.initialize(self)
  assert(is_num(x) and is_num(y) and is_num(width) and is_num(height))
  assert(is_num(tile_width) and is_num(tile_width))

  self.x, self.y = x, y
  self.width, self.height = width, height
  self.tile_width, self.tile_height = tile_width, tile_height

  self.render_queue = Skiplist.new(self.width * self.height * Map.render_queue_depth)

  self.grid = Grid:new(self.width, self.height)
  for x,y,_ in self.grid:each() do
    self.grid[x][y] = MapTile:new(self, x, y)
  end
  for _,_,tile in self.grid:each() do
    for _,_,neighbor in self.grid:each(tile.x - 1, tile.y - 1, 3, 3) do
      local dir_x, dir_y = neighbor.x - tile.x, neighbor.y - tile.y
      local direction = Direction[dir_x][dir_y]

      if direction then
        tile.siblings[direction] = neighbor
      end
    end
  end

  -- self.grid:g(10, 10).siblings[Direction.NORTH] = self.grid:g(5, 5)

  -- grid a* functions
  local function adjacency(tile)
    return pairs(tile.siblings)
  end

  local function cost(from, to)
    return to:cost_to_move_to()
  end

  local function distance(from, goal)
    return math.abs(goal.x - from.x) + math.abs(goal.y - from.y)
  end

  self.grid_astar = AStar:new(adjacency, cost, distance)
  -- local path = self.grid_astar:find_path(self.grid:g(1,1), self.grid:g(10, 10))
  -- for index,tile in ipairs(path) do
  --   tile.color = COLORS.red
  -- end
end

function Map:update(dt)
end

function Map:render()
  for x, y, tile in self.grid:each() do
    tile:render(self:grid_to_world_coords(x, y))
  end

  for index,entity in self.render_queue:ipairs() do
    entity:render()
  end
end

function Map:each(callback, x, y, width, height)
  assert(is_func(callback))
  x = x or 1
  y = y or 1
  width = width or self.width
  height = height or self.height
  -- width, height = width - 1, height - 1

  -- don't try to iterate outside of the grid bounds
  local x_diff, y_diff = 0, 0
  if x < 1 then
    x_diff = 1 - x
    x = 1
  end
  if y < 1 then
    y_diff = 1 - y
    y = 1
  end
  -- if you bump up x or y, bump down the width or height the same amount
  width, height = width - x_diff, height - y_diff
  if x + width > self.width then width = self.width - x end
  if y + height > self.height then height = self.height - y end

  local origin_tile =  self.grid:g(x, y)
  local tile, grid = origin_tile, self.grid

  callback(tile)

  local dir_x, dir_y = 0, 0
  for offset_x = 1, width do
    for offset_y = 1, height - 1 do
      dir_x, dir_y = 0, 1

      tile = tile.siblings[Direction[dir_x][dir_y]]
      callback(tile)
    end

    if offset_x < width then
      dir_x, dir_y = 1, 0

      tile = origin_tile.siblings[Direction[dir_x][dir_y]]
      origin_tile = tile
      callback(tile)
    end
  end
end

function Map:add_entity(entity)
  assert(instanceOf(MapEntity, entity))
  entity:insert_into_grid()
  self.render_queue:insert(entity)
end

function Map:remove_entity(entity)
  assert(instanceOf(MapEntity), entity)
  entity:remove_from_grid()
  self.render_queue:delete(entity)
end

function Map:grid_to_world_coords(x, y)
  return (x - 1) * self.tile_width + self.x, (y - 1) * self.tile_height + self.y
end

function Map:world_to_grid_coords(x, y)
  return math.floor(x / self.tile_width + self.x + 1), math.floor(y / self.tile_height - self.y + 1)
end

function Map.keypressed_up(self)
  self.player:move(Direction.NORTH:unpack())
end

function Map.keypressed_right(self)
  self.player:move(Direction.EAST:unpack())
end

function Map.keypressed_down(self)
  self.player:move(Direction.SOUTH:unpack())
end

function Map.keypressed_left(self)
  self.player:move(Direction.WEST:unpack())
end

local control_map = {
  keyboard = {
    on_press = {
      up =    Map.keypressed_up,
      right = Map.keypressed_right,
      down =  Map.keypressed_down,
      left =  Map.keypressed_left
    },
    on_release = {
    },
    on_update = {
    }
  }
}

function Map:mousepressed(x, y, button)
end

function Map:mousereleased(x, y, button)
end

function Map:keypressed(key, unicode)
  local action = control_map.keyboard.on_press[key]
  if type(action) == "function" then action(self) end

  local player_x, player_y = self:grid_to_world_coords(self.player.x, self.player.y)

  if key == " " then
    for k,v in pairs(self.grid:g(self.player.x, self.player.y).siblings) do
      print(k.x, k.y ,v)
    end
    print("-------------------")
  end
  -- the camera movement is too annoying
  -- needs to only adjust when it's near bounds or something
  -- game.camera:setPosition(player_x - g.getWidth() / 2, player_y - g.getHeight() / 2)
end

function Map:keyreleased(key, unicode)
end

function Map:joystickpressed(joystick, button)
  print(joystick, button)
end

function Map:joystickreleased(joystick, button)
  print(joystick, button)
end

function Map:focus(has_focus)
end

function Map:quit()
end
