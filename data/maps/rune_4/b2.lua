local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

dungeon_index = {}
dungeon_index = 4

end

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

  medusa_1:set_shooting(false)
  medusa_2:set_shooting(false)
  medusa_3:set_shooting(false)
  medusa_4:set_shooting(false)
end


function start_boss_sensor:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      game:start_dialog("rune_4.boss")
      hero:unfreeze()
      sol.audio.play_music("boss")
      fighting_boss = true

      medusa_1:set_shooting(true)
      medusa_2:set_shooting(true)
      medusa_3:set_shooting(true)
      medusa_4:set_shooting(true)

    end)
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    game:set_value("dungeon_4_finished",true)
    item:start_dungeon_finished_cutscene()
    map:open_doors("door_rune_4")
  end
end

if boss ~= nil then
  function boss:on_dying()
    -- Stop shooting fire during the cutscene.
    medusa_1:set_shooting(false)
    medusa_2:set_shooting(false)
    medusa_3:set_shooting(false)
    medusa_4:set_shooting(false)
  end
end

