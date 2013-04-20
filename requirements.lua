-- Helper assignments and erata
g = love.graphics
GRAVITY = 700
math.tau = math.pi * 2

-- The pixel grid is actually offset to the center of each pixel. So to get clean pixels drawn use 0.5 + integer increments.
g.setPoint(2.5, "rough")
math.randomseed(os.time())
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end
function string:split(sep) return self:match((self:gsub("[^"..sep.."]*"..sep, "([^"..sep.."]*)"..sep))) end
globalID = 0
function generateID() globalID = globalID + 1 return globalID end
function is_num(v) return type(v) == "number" end
function is_func(v) return type(v) == "function" end

-- Put any game-wide requirements in here
require 'lib/middleclass'
Stateful = require 'lib/stateful'
Skiplist = require "lib/skiplist"
HC = require 'lib/HardonCollider'
inspect = require 'lib/inspect'
require 'lib/AnAL'
require 'lib/table_save'
cron = require 'lib/cron'
COLORS = require 'lib/colors'
tween = require 'lib/tween'
beholder = require 'lib/beholder'
Grid = require 'lib/grid'
AStar = require 'lib/astar'
Replay = require 'lib/replay'

require 'base'
require 'game'
require 'stats_panel'
require 'map'
require 'map_tile'
require 'map_entity'

local function require_all(directory)
  local lfs = love.filesystem
  for index,filename in ipairs(lfs.enumerate(directory)) do
    local file = directory .. "/" .. filename
    if lfs.isFile(file) and file:match("%.lua$") then
      require(file:gsub("%.lua", ""))
    elseif lfs.isDirectory(file) then
      require_all(file)
    end
  end
end
require_all("states")
