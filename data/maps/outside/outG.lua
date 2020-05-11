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

function switch_barrier:on_activated()
         sol.timer.start(1000, function()      
           sol.audio.play_sound("secret")
           whirl:set_enabled(false)
         end)
end


end