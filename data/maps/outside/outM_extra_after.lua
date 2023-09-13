local map = ...
local game = map:get_game()
-- Outside world C3


function map:on_started(destination)

  local new_music
    new_music = "fanfare"
    sol.audio.play_music(new_music)

end

function sensor_rooftop:on_activated()

  game:start_dialog("outside_icarius_outM_extra.rooftop")

end
