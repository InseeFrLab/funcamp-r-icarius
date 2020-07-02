-- Outside D: Desert and Sandia Village.

local map = ...
local game = map:get_game()


-- Création de la table des bonnes réponses,
-- utilisée ensuite dans le menu igor_save_answer_chapter9
-- Initialisation à 0
good_answer_counter_chapter9 = {}
good_answer_counter_chapter9 = 0

function map:on_opening_transition_finished()
  sol.audio.play_music("dark_world")
end

function weak_wall:on_opened()
  sol.audio.play_sound("secret")
end


function mage_zilap:on_interaction()

  if game:get_value("icarius_chapitre4") then 
    game:start_dialog("outside_icarius_outD.mage_zilap_ask", function(answer)
       if answer == 3 then 
         game:start_dialog("outside_icarius_outD.mage_zilap_bravo")
         sol.timer.start(1000, function()      
          sol.audio.play_sound("secret")
          chest_feather_tidyverse:set_enabled(true)
          block_lift_1:set_weight(1)
         end)
      end
      if answer == 4 then
        game:start_dialog("outside_icarius_outD.mage_zilap_colere")
      end
   end)
  else 
    game:start_dialog("outside_icarius_outD.mage_zilap_start")
    game:set_value("icarius_chapitre4", true)
  end

end


function MamGrouxi:on_interaction()

  if good_answer_counter_chapter9 == 1 then 
    game:start_dialog("outside_icarius_outD.MamGrouxi_bravo")
    sol.timer.start(1000, function()      
      sol.audio.play_sound("secret")
      chest_bombs:set_enabled(true)
    end)
  else 
    game:start_dialog("outside_icarius_outD.MamGrouxi_start", function(answer)
      if answer == 3 then
        game:start_dialog("outside_icarius_outD.MamGrouxi_OK", function(answer)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter9")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
          if answer == 3 then
          end
        end)
      end
      if answer == 4 then
       game:start_dialog("outside_icarius_outD.MamGrouxi_KO")
      end
    end)
  end

end

