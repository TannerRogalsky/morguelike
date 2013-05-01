Direction = class('Direction', Base)

function Direction:initialize(x, y)
  Base.initialize(self)
  self.x = x
  self.y = y
end

function Direction:unpack()
  return self.x, self.y
end

Direction.NORTH = Direction:new(0, -1)
Direction.SOUTH = Direction:new(0, 1)
Direction.EAST = Direction:new(1, 0)
Direction.WEST = Direction:new(-1, 0)

Direction[-1], Direction[0], Direction[1] = {}, {}, {}
Direction[0][-1] = Direction.NORTH
Direction[0][1] = Direction.SOUTH
Direction[1][0] = Direction.EAST
Direction[-1][0] = Direction.WEST
