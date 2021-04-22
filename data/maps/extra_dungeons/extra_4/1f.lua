
local map = ...
local game = map:get_game()


local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

local fighting_boss = false

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  if boss ~= nil then
    boss:set_enabled(false)
  end

  map:set_doors_open("boss_door", true)

  if game:get_value("extra_dungeon_4_finished") == true then 
        start_boss_sensor:set_enabled(false)
        map:open_doors("boss_door")
  end

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function start_boss_sensor:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      game:start_dialog("extra_dungeons.extra_4.warning")
      hero:unfreeze()
      sol.audio.play_music("boss")
      fighting_boss = true
    end)
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "tunic" then
    item:start_dungeon_finished_cutscene()
  end
end