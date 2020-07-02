local map = ...
local game = map:get_game()

function chef_village:on_interaction()

  if good_answer_counter_chapter3 == 0 then
    if (game:get_value("grissgrass_quest") and game:get_value("grissgrass_quest_farmer_1") and game:get_value("grissgrass_quest_farmer_2")) then
      if game:get_value("grissgrass_igor_chapter3") then
        game:start_dialog("village_grissgrass.chef_village_2_a_short", function(answer)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter3")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
        end)
      else
         game:start_dialog("village_grissgrass.chef_village_2_a", function(answer)    
          game:set_value("grissgrass_igor_chapter3", true)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter3")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
       end)
      end
    else 
       game:start_dialog("village_grissgrass.chef_village_1")
       game:set_value("grissgrass_quest", true)
    end
  elseif good_answer_counter_chapter3 == 1 then
    game:start_dialog("village_grissgrass.chef_village_2_b")
    game:set_value("grissgrass_quest_part2", true)
  end

end

