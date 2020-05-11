local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- Restore usual settings.
  game:get_dialog_box():set_style("box")
  game:get_dialog_box():set_position("bottom")

  -- Disable other settings
  game:set_hud_enabled(false)
  game:set_pause_allowed(false)

  -- Having young children sleeping
  snores:get_sprite():set_ignore_suspend(true)
  snores_2:get_sprite():set_ignore_suspend(true)
  blond_mother:get_sprite():set_ignore_suspend(true)
  bed:get_sprite():set_animation("hero_sleeping")
  bed_young_girl:get_sprite():set_animation("hero_sleeping")
  hero:freeze()
  game:start_dialog("ending.ending_11")
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
