MapTile = class('MapTile', Base)

function MapTile:initialize(parent, x, y)
  Base.initialize(self)
  self.parent = parent
  self.x = x
  self.y = y

  self.color = COLORS.green
  self.content = {}
  self.siblings = {}
  self.secondary_directions = {}
end

function MapTile:update(dt)
end

function MapTile:has_content()
  if next(self.content) then
    return true
  else
    return false
  end
end

function MapTile:render(x, y)
  g.setColor(self.color.r, self.color.g, self.color.b, 50)
  g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  g.setColor(COLORS.black:rgb())
  g.rectangle("line", x, y, self.parent.tile_width, self.parent.tile_height)
  g.print(self.id, x + 0, y + 0, 0, 0.6)
end

function MapTile:cost_to_move_to()
  local cost = 0
  for _,content in pairs(self.content) do
    if is_func(content) then
      cost = cost + content:cost_to_move_to()
    elseif is_num(content) then
      cost = cost + content.cost_to_move_to
    end
  end
  return cost
end
