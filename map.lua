Map = class('Map', Base)

function Map:initialize()
  Base.initialize(self)

  self.grid = Grid:new(30, 30)
  for x,y,tile in self.grid:each() do
    self.grid[x][y] = MapTile:new(self, x, y)
  end

  local function adjacency(tile)
    local adjacent = {}
    for x, y, neighbor in self.grid:each(tile.x - 1, tile.y - 1, 3, 3) do
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
    return 0
  end

  local astar = AStar:new(adjacency, cost, distance)
  local path = astar:find_path(self.grid:g(1,1), self.grid:g(10, 16))
  for index,tile in ipairs(path) do
    tile.color = COLORS.red
  end
end

function Map:update(dt)
end

function Map:render()
  for x, y, tile in self.grid:each() do
    tile:render(x * 10, y * 10)
  end
end

function Map:mousepressed(x, y, button)
end

function Map:mousereleased(x, y, button)
end

function Map:keypressed(key, unicode)
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
