Direction = class('Direction', Base)

function Direction:initialize(x, y)
  Base.initialize(self)
  self.x = x
  self.y = y
end

function Direction:unpack()
  return self.x, self.y
end

function Direction:cardinal_name()
  if self.x == 0 and self.y == -1 then
    return "NORTH"
  elseif self.x == 0 and self.y == 1 then
    return "SOUTH"
  elseif self.x == 1 and self.y == 0 then
    return "EAST"
  elseif self.x == -1 and self.y == 0 then
    return "WEST"
  end
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
