Floor = class('Floor', MapEntity)

function Floor:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)
end

function Floor:render()
  self.parent:each(function(tile)
    g.setColor(COLORS.white:rgb())
    local x, y = self.parent:grid_to_world_coords(tile.x, tile.y)
    g.rectangle("fill", x, y, self.parent.tile_width, self.parent.tile_height)
  end, self.x, self.y, self.width, self.height)
end

Floor.__lt = MapEntity.__lt
Floor.__le = MapEntity.__le
