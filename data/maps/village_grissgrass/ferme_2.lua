local map = ...
local game = map:get_game()



function fermier_2:on_interaction()


 if game:get_value("grissgrass_quest_part2") then

   if good_answer_counter_chapter7 == 0 then

      if game:get_value("grissgrass_igor_chapter7") then
        game:start_dialog("village_grissgrass.fermier_2_b_short", function(answer)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter7")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
        end)
      else
         game:start_dialog("village_grissgrass.fermier_2_b", function(answer)    
         game:set_value("grissgrass_igor_chapter7", true)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter7")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
       end)
      end

    elseif good_answer_counter_chapter7 == 1 then

     game:start_dialog("village_grissgrass.fermier_2_c")
         sol.timer.start(1000, function()      
          sol.audio.play_sound("secret")
          chest_elixir_mandragore:set_enabled(true)
          game:set_value("grissgrass_elixir_mandragore", true)
         end)

    end

  else

    game:start_dialog("village_grissgrass.fermier_2")
    game:set_value("grissgrass_quest_farmer_2", true)

  end


end

