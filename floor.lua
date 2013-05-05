Floor = class('Floor', MapEntity)

function Floor:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.image = game.preloaded_image["50x50_0003_concrete-square.png"]
  self.z = 1
end

function Floor:render()
  local x, y = self.parent:grid_to_world_coords(self.x, self.y)
  g.setColor(COLORS.white:rgb())
  g.draw(self.image, x, y)
end

Floor.__lt = MapEntity.__lt
Floor.__le = MapEntity.__le
