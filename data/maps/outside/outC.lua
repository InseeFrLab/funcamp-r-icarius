
local map = ...
local game = map:get_game()


-- Launch the answer screen on interaction


function map:on_opening_transition_finished()
  sol.audio.play_music("dark_world")
      pacman_ghost_1:set_enabled(false)
      pacman_ghost_2:set_enabled(false)
      pacman_ghost_3:set_enabled(false)
      pacman_ghost_4:set_enabled(false)
end


function mage_delagarde:on_interaction()

 game:start_dialog("outside_icarius_outC.mage_delagarde_answer", function(answer)
        if answer == 2 then
        game:start_dialog("outside_icarius_outC.mage_delagarde_go")
        end
        if answer == 3 then
        game:start_dialog("outside_icarius_outC.mage_delagarde_nogo")
        end
  end)
   
end


function sensor_pacman:on_activated()

  if game:get_value("mode_pacman") then
    sol.audio.stop_music("dark_world")
    sol.audio.play_music("pacman")
      pacman_ghost_1:set_enabled(true)
      pacman_ghost_2:set_enabled(true)
      pacman_ghost_3:set_enabled(true)
      pacman_ghost_4:set_enabled(true)
  end

end

function sensor_pacman_2:on_activated()

  if game:get_value("mode_pacman") then
    sol.audio.stop_music("pacman")
    sol.audio.play_music("dark_world")
      pacman_ghost_1:set_enabled(false)
      pacman_ghost_2:set_enabled(false)
      pacman_ghost_3:set_enabled(false)
      pacman_ghost_4:set_enabled(false)
  end

end
