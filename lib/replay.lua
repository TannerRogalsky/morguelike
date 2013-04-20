local Replay = class('Replay')

function Replay:initialize(id)
  self.id = id or math.random()
  self.action_queue = {}
end

function Replay.load(id)
  local action_queue = table.load("replay_" .. id)
  local replay = Replay:new(id)
  replay.action_queue = action_queue
  return replay
end

function Replay:play(tick)
  assert(type(tick) == "number" and tick > 0)
  local action_index = 1
  self.cron_id = cron.every(tick, function()
    love.event.push(unpack(self.action_queue[action_index]))
    action_index = action_index + 1
    if self.action_queue[action_index] == nil then
      cron.cancel(self.cron_id)
    end
  end)
end

function Replay:mousepressed(x, y, button)
  table.insert(self.action_queue, {"mousepressed", x, y, button})
end

function Replay:mousereleased(x, y, button)
  table.insert(self.action_queue, {"mousereleased", x, y, button})
end

function Replay:keypressed(key, unicode)
  table.insert(self.action_queue, {"keypressed", key, unicode})
end

function Replay:keyreleased(key, unicode)
  table.insert(self.action_queue, {"keyreleased", key, unicode})
end

function Replay:joystickpressed(joystick, button)
  table.insert(self.action_queue, {"joystickpressed", joystick, button})
end

function Replay:joystickreleased(joystick, button)
  table.insert(self.action_queue, {"joystickreleased", joystick, button})
end

function Replay:focus(has_focus)
end

function Replay:save()
  table.save(self.action_queue, "replay_" .. self.id)
end

function Replay:quit()
  self:save()
end

return Replay
