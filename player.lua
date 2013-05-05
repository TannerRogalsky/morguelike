Player = class('Player', MapEntity)

function Player:initialize(parent, x, y, width, height, z)
  MapEntity.initialize(self, parent, x, y, width, height, z)

  self.z = 5
  self.image = game.preloaded_image["50x50_guy.png"]
  self.front_animation = newAnimation(game.preloaded_image["char_front_nohandle.png"], 50, 50, 0.2, 4)
  self.side_animation = newAnimation(game.preloaded_image["char_side.png"], 50, 50, 0.2, 4)
  self.back_animation = newAnimation(game.preloaded_image["char_back.png"], 50, 50, 0.2, 4)

  self.animations = {}
  self.animations[Direction.NORTH] = self.back_animation
  self.animations[Direction.SOUTH] = self.front_animation
  self.animations[Direction.EAST] = self.side_animation
  self.animations[Direction.WEST] = self.side_animation

  self.animation = self.side_animation

  self.out_pos, self.in_pos = {}, {}
  self.tween_out, self.tween_in = nil, nil
  self.out_dir, self.in_dir = Direction.EAST, Direction.EAST

  self.footstep1 = love.audio.newSource("sounds/stepa.ogg", "static")
  self.footstep1:setVolume(0.2)
  self.footstep2 = love.audio.newSource("sounds/stepb.ogg", "static")
  self.footstep2:setVolume(0.2)
  self.movefail1 = love.audio.newSource("sounds/Ooof_1.ogg", "static")
  self.movefail1:setVolume(0.1)
  self.movefail2 = love.audio.newSource("sounds/Ooof_2.ogg", "static")
  self.movefail2:setVolume(0.1)
  self.movefail3 = love.audio.newSource("sounds/Ooof_3.ogg", "static")
  self.movefail3:setVolume(0.1)

  step = 0
  fail = 0
end

function Player:update(dt)
  for dir,animation in pairs(self.animations) do
    animation:update(dt)
  end
end

function Player:render()
  g.setColor(COLORS.blue:rgb())
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

function Player:draw_image(x, y, direction)
  g.setColor(COLORS.white:rgb())
  if direction == Direction.EAST then
    self.animations[direction]:draw(x, y)
  elseif direction == Direction.WEST then
    self.animations[direction]:draw(x, y, 0, direction.x, 1, self.parent.tile_width)
  elseif direction == Direction.NORTH then
    self.animations[direction]:draw(x, y)
  elseif direction == Direction.SOUTH then
    self.animations[direction]:draw(x, y)
  else
    g.draw(self.image, x, y)
  end
end

function Player:move(delta_x, delta_y)
  -- we're already tweening. don't move again
  if self.tween_out and self.tween_in then
    return false
  end

  self:remove_from_grid()
  local current_tile = self.parent.grid:g(self.x, self.y)
  local dir = Direction[delta_x][delta_y]
  local new_tile = current_tile.siblings[dir]
  --  the 'or dir' part of this is a major bandaid and should absolutely not be necessary
  local secondary_dir = current_tile.secondary_directions[dir] or dir
  -- print("***********")
  -- print(dir:cardinal_name(), secondary_dir:cardinal_name())
  -- print(current_tile, new_tile)
  -- for k,v in pairs(current_tile.secondary_directions) do
  --   print(k,v:cardinal_name())
  -- end

  -- successful move
  local can_move = false
  for id,entity in pairs(new_tile.content) do
    if instanceOf(Floor, entity) then
      can_move = true
    elseif instanceOf(Block, entity) then
      local block_can_move = entity:move(secondary_dir.x, secondary_dir.y)
      can_move = block_can_move

      if can_move == false then
        if fail == 0 then
            love.audio.play(self.movefail1)
            love.audio.rewind(self.movefail1)
            fail = fail + 1
          elseif fail == 1 then
            love.audio.play(self.movefail2)
            love.audio.rewind(self.movefail2)
            fail = fail + 1
          elseif fail == 2 then
            love.audio.play(self.movefail3)
            love.audio.rewind(self.movefail3)
            fail = 0
        end
        break
      end
    end
  end

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

  if step == 0 then
    love.audio.play(self.footstep1)
    love.audio.rewind(self.footstep1)
    step = step + 1
  else
    love.audio.play(self.footstep2)
    love.audio.rewind(self.footstep2)
    step = step - 1
 end
  end

  self:insert_into_grid()
  return can_move
end

Player.__lt = MapEntity.__lt
Player.__le = MapEntity.__le
