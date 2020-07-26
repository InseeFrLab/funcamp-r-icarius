
local map = ...
local game = map:get_game()


function map:on_started()

dungeon_index = {}
dungeon_index = 1

  if game:get_value("dungeon_1_finished") == true then 
        start_boss_sensor:set_enabled(false)
        map:open_doors("door_rune_1")
        map:close_doors("door_rune_2")   
  else
        map:open_doors("door_rune_2")
  end

end


function map:on_opening_transition_finished()
  sol.audio.play_sound("bounce")
  sol.audio.play_music("dark_mountain")
end

function start_boss_sensor:on_activated()
      game:start_dialog("rune_1.boss")
      start_boss_sensor:set_enabled(false)
end

function close_back_door_sensor:on_activated()
      map:close_doors("door_rune_2")
end


function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    game:set_value("dungeon_1_finished",true)
    item:start_dungeon_finished_cutscene()
    map:open_doors("door_rune_1")
  end
end

