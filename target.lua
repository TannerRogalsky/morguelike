Target = class('Target', MapEntity)

function Target:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)
end

function Target:render()
  self.parent:each(function(tile)
    g.setColor(COLORS.pink:rgb())
    local x, y = self.parent:grid_to_world_coords(tile.x, tile.y)
    g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  end, self.x, self.y, self.width, self.height)
end

Target.__lt = MapEntity.__lt
Target.__le = MapEntity.__le
