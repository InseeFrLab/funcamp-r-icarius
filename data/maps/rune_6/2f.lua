local map = ...
local game = map:get_game()

local night_overlay = sol.surface.create(map:get_size())
local alpha = 0
night_overlay:fill_color({0, 0, 64, alpha})

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

local fighting_boss = false

function map:on_started()

  if boss ~= nil then
    boss:set_enabled(false)
  end
  map:set_doors_open("boss_door", true)

end

function start_boss_sensor:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      game:start_dialog("rune_6.boss")
      hero:unfreeze()
      sol.audio.play_music("boss")
      fighting_boss = true
    end)
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    item:start_dungeon_finished_cutscene()
  end
end

function sensor_teleport_boss:on_activated()

game:start_dialog("rune_6.teleport", function()

          -- freeze the hero
          hero:freeze()

          -- when dialog ended, make the map darker and darker
          sol.timer.start(map, 20, function()
            alpha = alpha + 1
            if alpha >= 192 then
              
              alpha = 192    
              -- when screen is dark,      
              -- move hero back to boss entry
              hero:teleport("rune_6/2f", "boss_entry")

            end
            night_overlay:clear()
            night_overlay:fill_color({0, 0, 64, alpha})

            -- Continue the timer if there is still light.
            return alpha < 192
          end)

      end)




end