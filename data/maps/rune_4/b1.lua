
local map = ...
local game = map:get_game()


function map:on_started()

  medusa_1:set_shooting(false)
  medusa_2:set_shooting(false)
  medusa_3:set_shooting(false)
  medusa_4:set_shooting(false)
  medusa_5:set_shooting(false)

end


function start_medusa_sensor:on_activated()

  if not medusa_challenge then
    hero:freeze()
    sol.timer.start(1000, function()
      hero:unfreeze()
      sol.audio.play_music("boss")
      medusa_challenge = true

      medusa_1:set_shooting(true)
      medusa_2:set_shooting(true)
      medusa_3:set_shooting(true)
      medusa_4:set_shooting(true)
      medusa_5:set_shooting(true)
    end)
  end
end


function stop_medusa_sensor:on_activated()

      sol.audio.stop_music("boss")
      sol.audio.play_music("cave")

      medusa_challenge = false

      medusa_1:set_shooting(false)
      medusa_2:set_shooting(false)
      medusa_3:set_shooting(false)
      medusa_4:set_shooting(false)
      medusa_5:set_shooting(false)

end