
local map = ...
local game = map:get_game()


function map:on_started()

dungeon_index = {}
dungeon_index = 1

end


function map:on_opening_transition_finished()

  sol.audio.play_sound("bounce")
  sol.audio.play_music("dark_mountain")
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "rune" then
    game:set_value("dungeon_1_finished",true)
    item:start_dungeon_finished_cutscene()
    map:open_doors("door_rune")
  end
end

