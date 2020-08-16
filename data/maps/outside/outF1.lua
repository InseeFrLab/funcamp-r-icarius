local map = ...
local game = map:get_game()


function sensor_landslide:on_activated()
  sol.timer.start(map, 1000, function()
    sol.audio.play_sound("explosion")
    outside_stone_to_grissgrass:set_enabled(true)
    game:start_dialog("outside_icarius_outF1.landslide")
    sensor_landslide:set_enabled(false)
  end)
end
