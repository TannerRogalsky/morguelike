Map = class('Map', Base)

function Map:initialize()
  Base.initialize(self)

  self.grid = Grid:new(30, 30)
  for x,y,tile in self.grid:each() do
    self.grid[x][y] = MapTile:new(self, x, y)
  end

  local function adjacency(tile)
    local adjacent = {}
    for x, y, neighbor in tile.parent.grid:each(tile.x - 1, tile.y - 1, 3, 3) do
      if not(x == tile.x and y == tile.y) then
        table.insert(adjacent, neighbor)
      end
    end
    return ipairs(adjacent)
  end

  local function cost(from, to)
    return 1
  end

  local function distance(from, goal)
    return math.abs(goal.x - from.x) + math.abs(goal.y - from.y)
  end

  local astar = AStar:new(adjacency, cost, distance)
  local path = astar:find_path(self.grid:g(1,1), self.grid:g(10, 16))
  for index,tile in ipairs(path) do
    tile.color = COLORS.red
  end


  self.player = MapEntity:new(self, 15, 15)
  self.grid:g(15, 15).content[self.player.id] = self.player
end

function Map:update(dt)
end

function Map:render(offset_x, offset_y)
  for x, y, tile in self.grid:each() do
    tile:render((x - 1) * 10 + offset_x, (y - 1) * 10 + offset_y)
  end
end

function Map:mousepressed(x, y, button)
end

function Map:mousereleased(x, y, button)
end

local control_map = {
  keyboard = {
    on_press = {
      up =    function(self) self.player:move(0, -1) end,
      right = function(self) self.player:move(1, 0) end,
      down =  function(self) self.player:move(0, 1) end,
      left =  function(self) self.player:move(-1, 0) end
    },
    on_release = {
    },
    on_update = {
    }
  }
}

function Map:keypressed(key, unicode)
  local action = control_map.keyboard.on_press[key]
  if type(action) == "function" then action(self) end
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
