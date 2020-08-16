-- Outside I: Ruins
local map = ...
local game = map:get_game()


function weak_wall:on_opened()
  sol.audio.play_sound("secret")
end

function sensor_landslide:on_activated()
  sol.timer.start(map, 1000, function()
    sol.audio.play_sound("explosion")
    outside_stone_temple:set_enabled(true)
    game:start_dialog("outside_icarius_outI.landslide")
    sensor_landslide:set_enabled(false)
  end)
end

if game:get_value("possession_magic_medallion") then
  outside_medallion_cave:set_enabled(true)
end