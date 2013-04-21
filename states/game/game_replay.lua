local GameReplay = Game:addState('GameReplay')

function GameReplay:enteredState()
  local r = Replay.load("test")
  r:play(0.05, function()
    -- print("done")
    self:gotoState("Main")
  end)
end

function GameReplay:exitedState()
end

return GameReplay
