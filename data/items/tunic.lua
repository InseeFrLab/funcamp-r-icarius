local item = ...
local game = item:get_game()

function item:on_created()

  self:set_savegame_variable("possession_tunic")
end

function item:on_obtained(variant, savegame_variable)
  -- Give the built-in ability "tunic", but only after the treasure sequence is done.
  self:get_game():set_ability("tunic", variant)
end

local function victory_cutscene()

  local map = game:get_map()
  local hero = map:get_hero()

  sol.audio.play_music("victory")
  hero:set_direction(3)
  game:set_life(game:get_max_life())
  sol.timer.start(9000, function()
    hero:start_victory(function()
      game:start_dialog("dungeon_finished_save", function(answer)
        sol.audio.play_sound("danger")
        if answer == 3 then
          game:save()
        end
        hero:unfreeze()
        map:open_doors("boss_door")
      end)
    end)
  end)

end

function item:start_dungeon_finished_cutscene()

  local map = game:get_map()
  local hero = map:get_hero()
  hero:freeze()
  game:set_dungeon_finished()

  game:start_dialog("extra_dungeons.congratulations", victory_cutscene)


end
