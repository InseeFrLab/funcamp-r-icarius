
local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

dungeon_index = {}
dungeon_index = 2

  if game:get_value("dungeon_2_finished") == true then 
        start_boss_sensor:set_enabled(false)
        sensor_leaving_dungeon:set_enabled(false)
        map:open_doors("door_rune")
        ropa_1:set_enabled(false)
        ropa_2:set_enabled(false)
        ropa_3:set_enabled(false)
        ropa_4:set_enabled(false)
  else
        ropa_1:immobilize()
        ropa_2:immobilize()
        ropa_3:immobilize()
        ropa_4:immobilize()
  end

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

  sol.audio.play_sound("bounce")
  sol.audio.play_music("dark_mountain")

end


function start_boss_sensor:on_activated()
      game:start_dialog("rune_2.boss")
      start_boss_sensor:set_enabled(false)
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    sensor_leaving_dungeon:set_enabled(true)
    game:set_value("dungeon_2_finished",true)
    item:start_dungeon_finished_cutscene()
    map:open_doors("door_rune")
  end

end

function sensor_leaving_dungeon:on_activated()
        game:start_dialog("rune_2.release")
end

