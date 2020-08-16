-- Outside D: Desert and Sandia Village.

local map = ...
local game = map:get_game()


function map:on_opening_transition_finished()
  sol.audio.play_music("dark_world")
end

function weak_wall:on_opened()
  sol.audio.play_sound("secret")
end


function mage_zilap:on_interaction()

  if game:get_value("chapter8_answer") then 
    game:start_dialog("outside_icarius_outD.mage_zilap_ask", function(answer)
       if answer == 3 then 
         game:start_dialog("outside_icarius_outD.mage_zilap_bravo")
         sol.timer.start(1000, function()      
          sol.audio.play_sound("secret")
          chest_feather_tidyverse:set_enabled(true)
          block_lift_1:set_weight(1)
          mage_zilap:set_enabled(false)
         end)
      end
      if answer == 4 then
        game:start_dialog("outside_icarius_outD.mage_zilap_colere")
      end
   end)
  else 
    game:start_dialog("outside_icarius_outD.mage_zilap_start")
    game:set_value("chapter8_answer", true)
  end

end


 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 9
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


function MamGrouxi:on_interaction()

    game:start_dialog("outside_icarius_outD.MamGrouxi_start", function(answer)
      if answer == 3 then
        game:start_dialog("outside_icarius_outD.MamGrouxi_OK", function(answer)
          if answer == 2 then
            hero:freeze()
            local save_answers_menu = file()
            sol.menu.start(map, save_answers_menu, on_top)
          end
        end)
      end
      if answer == 4 then
       game:start_dialog("outside_icarius_outD.MamGrouxi_KO")
      end
    end)

end

-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
    game:start_dialog("outside_icarius_outD.MamGrouxi_bravo")
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        chest_bombs:set_enabled(true)
        MamGrouxi:set_enabled(false)
        sol.audio.play_music("dark_mountain")
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter9_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)



if game:get_value("chapter8_answer") then
        block_lift_1:set_weight(1)
        mage_zilap:set_enabled(false)
end


if game:get_value("chapter9_answer") then
        MamGrouxi:set_enabled(false)
end