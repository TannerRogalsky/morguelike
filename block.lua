Block = class('Block', MapEntity)

function Block:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.z = 5

  self.out_pos, self.in_pos = {}, {}
  self.out_dir, self.in_dir = Direction.EAST, Direction.EAST
  self.tween_out, self.tween_in = nil, nil

  self.images = {}
  self.images[Direction.NORTH] = game.preloaded_image["50x50__0006_cart-front.png"]
  self.images[Direction.SOUTH] = game.preloaded_image["50x50__0007_cart-back.png"]
  self.images[Direction.EAST] = game.preloaded_image["50x50_0007_cart-side.png"]
  self.images[Direction.WEST] = game.preloaded_image["50x50_0007_cart-side.png"]

  self.scr1 = love.audio.newSource("sounds/scrape1.ogg", "static")
  self.scr1:setVolume(0.2)
  self.scr2 = love.audio.newSource("sounds/scrape2.ogg", "static")
  self.scr2:setVolume(0.2)
  self.scr3 = love.audio.newSource("sounds/scrape3.ogg", "static")
  self.scr3:setVolume(0.2)
  self.scr4 = love.audio.newSource("sounds/scrape4.ogg", "static")
  self.scr4:setVolume(0.2)
  scrape = 0

  self.chime = love.audio.newSource("sounds/success.ogg", "static")
  self.chime:setVolume(0.12)
end

function Block:draw_image(x, y, direction)
  g.setColor(COLORS.white:rgb())
  if direction == Direction.EAST then
    g.draw(self.images[direction], x, y)
  elseif direction == Direction.WEST then
    g.draw(self.images[direction], x, y, 0, direction.x, 1, self.parent.tile_width)
  elseif direction == Direction.NORTH then
    g.draw(self.images[direction], x, y)
  elseif direction == Direction.SOUTH then
    g.draw(self.images[direction], x, y)
  else
    g.draw(self.image, x, y)
  end
end

function Block:is_on_target()
  for id,entity in pairs(self.parent.grid:g(self.x, self.y).content) do
    if instanceOf(Target, entity) then
      return true
    end
  end
  return false
end

function Block:render()
  g.setColor(COLORS.red:rgb())
  if self.tween_out and self.tween_in then

    local x, y = self.parent:grid_to_world_coords(self.old_tile.x, self.old_tile.y)
    g.setScissor(x, y, self.parent.tile_width, self.parent.tile_height)
    self:draw_image(self.out_pos.x, self.out_pos.y, self.out_dir)

    x, y = self.parent:grid_to_world_coords(self.new_tile.x, self.new_tile.y)
    g.setScissor(x, y, self.parent.tile_width, self.parent.tile_height)
    self:draw_image(self.in_pos.x, self.in_pos.y, self.in_dir)

    g.setScissor()
  else
    local x, y = self.parent:grid_to_world_coords(self.x, self.y)
    self:draw_image(x, y, self.in_dir)
  end
end

local function block_moved(self)
  local all_blocks_on_targets = false
  for index,entity in ipairs(self.parent.entity_list) do
    if instanceOf(Block, entity) then
      all_blocks_on_targets = entity:is_on_target()
      if all_blocks_on_targets == false then break end
    end
  end

  if all_blocks_on_targets then
    -- level over
    print("YOU JUST WON. YOU JUST WON THE GAME. YOU JUST WON. YOU JUST WON THE GAME.")
    game.active_map_index = game.active_map_index + 1
    game:gotoState("Main", game.maps[game.active_map_index])
    game:gotoState("Menu")
  end
end

function Block:move(delta_x, delta_y)
  self:remove_from_grid()
  local current_tile = self.parent.grid:g(self.x, self.y)
  local dir = Direction[delta_x][delta_y]
  local new_tile = current_tile.siblings[dir]
  local secondary_dir = current_tile.secondary_directions[dir] or dir

  local can_move = false
  for id,entity in pairs(new_tile.content) do
    if instanceOf(Floor, entity) then
      can_move = true
    elseif instanceOf(Block, entity) then
      can_move = false
      break
    elseif instanceOf(Target, entity) then
      can_move = true
      love.audio.play(self.chime)
      love.audio.rewind(self.chime)
    end
  end

  -- we're already tweening. don't move again
  if self.tween_out and self.tween_in then
    can_move = false
  end

  -- successful move
  if can_move then
    self.new_tile, self.old_tile = new_tile, current_tile
    self.x, self.y = new_tile.x, new_tile.y

    local tween_speed = 0.2

    self.out_pos = {}
    self.out_pos.x, self.out_pos.y = self.parent:grid_to_world_coords(self.old_tile.x, self.old_tile.y)
    local target_out = {}
    target_out.x, target_out.y = self.parent:grid_to_world_coords(self.old_tile.x + delta_x, self.old_tile.y + delta_y)
    self.tween_out = tween(tween_speed, self.out_pos, target_out, "linear", function() self.tween_out = nil end)

    self.in_pos = {}
    self.in_pos.x, self.in_pos.y = self.parent:grid_to_world_coords(self.new_tile.x - secondary_dir.x, self.new_tile.y - secondary_dir.y)
    local target_in = {}
    target_in.x, target_in.y = self.parent:grid_to_world_coords(self.new_tile.x, self.new_tile.y)
    self.tween_in = tween(tween_speed, self.in_pos, target_in, "linear", function() self.tween_in = nil end)

    self.out_dir = dir
    self.in_dir = secondary_dir

    cron.after(tween_speed, block_moved, self)

    if scrape == 0 then
      love.audio.play(self.scr1)
      love.audio.rewind(self.scr1)
      scrape = scrape + 1
    elseif scrape == 1 then
      love.audio.play(self.scr2)
      love.audio.rewind(self.scr2)
      scrape = scrape + 1
    elseif scrape == 2 then
      love.audio.play(self.scr3)
      love.audio.rewind(self.scr3)
      scrape = scrape + 1
    elseif scrape == 3 then
      love.audio.play(self.scr4)
      love.audio.rewind(self.scr4)
      scrape = 0
    end
  end

  self:insert_into_grid()
  return can_move
end

Block.__lt = MapEntity.__lt
Block.__le = MapEntity.__le
