local map = ...
local game = map:get_game()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 4
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


-- Set dialogs with farmer

function fermier_2:on_interaction()

 if game:get_value("grissgrass_quest_part2") then

   if game:get_value("chapter4_answer") == nil then

      if game:get_value("grissgrass_igor_chapter4") then
        game:start_dialog("village_grissgrass.fermier_2_b_short", function(answer)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
        end)
      else
         game:start_dialog("village_grissgrass.fermier_2_b", function(answer)    
         game:set_value("grissgrass_igor_chapter4", true)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
       end)
      end

    end

  else
    game:start_dialog("village_grissgrass.fermier_2")
    game:set_value("grissgrass_quest_farmer_2", true)
  end

end


-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
      game:start_dialog("village_grissgrass.fermier_2_c")
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        chest_elixir_mandragore:set_enabled(true)
        sensor_warning_chest:set_enabled(true)
        game:set_value("grissgrass_elixir_mandragore", true)
        fermier_2:set_enabled(false)
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter4_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


-- Unable farmer if quest already done
if game:get_value("chapter4_answer") then
  fermier_2:set_enabled(false)
end


-- Make sure Chest if opened before leaving
function sensor_warning_chest:on_activated()
    game:start_dialog("village_grissgrass.warning_chest")
    sensor_warning_chest:set_enabled(false)
end