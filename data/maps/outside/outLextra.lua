local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end


function little_tree:on_interaction()

  game:start_dialog("outside_icarius_outLextra.little_tree")
  sol.timer.start(1000, function()      
    sol.audio.play_sound("secret")
    little_tree:set_enabled(false)
  end)

end