Target = class('Target', MapEntity)

function Target:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.image = game.preloaded_image["50x50_0000_marker.png"]

  self.z = 3
end

function Target:render()
  g.setColor(COLORS.white:rgb())
  local x, y = self.parent:grid_to_world_coords(self.x, self.y)
  g.draw(self.image, x, y)
  -- self.parent:each(function(tile)
  --   g.setColor(COLORS.pink:rgb())
  --   local x, y = self.parent:grid_to_world_coords(tile.x, tile.y)
  --   g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  -- end, self.x, self.y, self.width, self.height)
end

Target.__lt = MapEntity.__lt
Target.__le = MapEntity.__le
