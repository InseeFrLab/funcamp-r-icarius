local map = ...
local game = map:get_game()
-- Outside extra world M



function map:on_started(destination)
  local new_music
  new_music = "overworld"
  sol.audio.play_music(new_music)
end


 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 14
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


-- Set dialogs with PNJ
function chief_village:on_interaction()

  if game:get_value("phocea_quest_pnj1") == nil or game:get_value("phocea_quest_pnj2") == nil or game:get_value("phocea_quest_pnj3") == nil then     
    if game:get_value("phocea_quest") == nil then
       game:start_dialog("outside_icarius_outM_extra.chief_village_1")
       game:set_value("phocea_quest", true)
    else
       game:start_dialog("outside_icarius_outM_extra.chief_village_2")
    end
  else

    game:start_dialog("outside_icarius_outM_extra.chief_village_3", function(answer)
      if answer == 3 then
        game:start_dialog("outside_icarius_outM_extra.chief_village_4", function(answer)
          if answer == 2 then
            hero:freeze()
            local save_answers_menu = file()
            sol.menu.start(map, save_answers_menu, on_top)
          end
        end)
      end
      if answer == 4 then
       game:start_dialog("outside_icarius_outM_extra.chief_village_KO")
      end
    end)

  end

end


-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
    game:start_dialog("outside_icarius_outM_extra.chief_village_5")
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        chief_village:set_enabled(false)
        vegetal_ladder:set_enabled(true)
        sol.audio.play_music("dark_mountain")
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter14_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


if game:get_value("chapter14_answer") then
        chief_village:set_enabled(false)
        vegetal_ladder:set_enabled(true)
end