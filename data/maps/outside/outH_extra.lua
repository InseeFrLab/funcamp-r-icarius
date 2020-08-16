local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_warp_zone:on_activated()
      game:start_dialog("outside_icarius_outH_extra.warp_zone")
      sensor_warp_zone:set_enabled(false)
end