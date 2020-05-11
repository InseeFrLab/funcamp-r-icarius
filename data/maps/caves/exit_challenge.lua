local map = ...
local game = map:get_game()

local night_overlay = sol.surface.create(map:get_size())
local alpha = 0
night_overlay:fill_color({0, 0, 64, alpha})

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

function impossible_path_start_sensor:on_activated()

-- Starting message
    game:start_dialog("exit_challenge.start")
    sol.audio.play_music("sanctuary")
    impossible_path_start_sensor:set_enabled(false)

-- Statia message explaining the trap
    sol.timer.start(20000, function()

      game:start_dialog("exit_challenge.statia_message", function()

          -- freeze the hero
          hero:freeze()

          -- when dialog ended, make the map darker and darker
          sol.timer.start(map, 20, function()
            alpha = alpha + 1
            if alpha >= 192 then
              
              alpha = 192    
              -- when screen is dark,      
              -- move hero to the starting point of exit challenge
              hero:teleport("caves/exit_challenge", "from_start_magical_path_M")

            end
            night_overlay:clear()
            night_overlay:fill_color({0, 0, 64, alpha})

            -- Continue the timer if there is still light.
            return alpha < 192
          end)

      end)

    end)
end

function impossible_path_stop_sensor:on_activated()

-- Exit message
    sol.audio.play_sound("secret")
    game:start_dialog("exit_challenge.exit")
    impossible_path_start_sensor:set_enabled(false)
    sol.audio.play_music("triforce")

end

function konami_shield_sensor:on_activated()

-- Exit message
    game:start_dialog("exit_challenge.konami_shield")
    konami_shield_sensor:set_enabled(false)

end

end