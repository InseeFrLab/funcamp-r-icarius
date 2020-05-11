local map = ...
local game = map:get_game()

function map:on_started()

dungeon_index = {}
dungeon_index = 4

end


local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)


function sensor_boss_warning_1:on_activated()
    game:start_dialog("castle.boss_warning_1")
    sensor_boss_warning_1:set_enabled(false)
end

function sensor_boss_warning_2:on_activated()
    game:start_dialog("castle.boss_warning_2")
    sensor_boss_warning_2:set_enabled(false)
end


local fighting_boss = false

function map:on_started(destination)

  if boss ~= nil then
    boss:set_enabled(false)
  end
  map:set_doors_open("boss_door", true)

end

function sensor_boss_start:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      hero:unfreeze()
      sol.audio.play_music("ganon_battle")
      game:start_dialog("castle.boss_start")
      fighting_boss = true

    end)
  end
end

function map:on_started()

  if boss ~= nil then
    boss:set_enabled(false)
    sensor_boss_warning_2:set_enabled(false)
  end
  map:set_doors_open("boss_door", true)

end


-- Call a function every second.
sol.timer.start(1000, function()
  if  game:get_life() == 2 then
  game:start_dialog("castle.boss_warning_3")
    sol.timer.start(500, function()
      sol.audio.play_sound("secret")
      game:set_life(6)
    end)
  end
  return true  -- To call the timer again (with the same delay).
end)

-- Call a function every second.
sol.timer.start(1000, function()

  if boss:get_life() > 2 then
    return true
  else 
    game:start_dialog("castle.boss_warning_4")
    sol.timer.start(200, function()
      boss:set_life(0)
    end)
    return false
  end
  -- To call the timer again (with the same delay).
end)

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    item:start_dungeon_finished_cutscene()
    map:open_doors("door_rune")
  end
end

