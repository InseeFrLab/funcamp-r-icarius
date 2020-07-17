-- Outside H: Lake
local map = ...
local game = map:get_game()

local igor_chapter12_success = 0

-- Global variable set up to keep track of good answers
good_answer_table = {}

function chatty_bird:on_interaction()

  if game:get_value("chatty_bird_OK") then 

    if igor_chapter12_success == 0 then

      game:start_dialog("outside_icarius_outH.chatty_bird_answer", function(answer)
        if answer == 2 then
          hero:freeze()
          local igor_save_answer_menu_chapter_12 = require("scripts/menus/igor_save_answer_chapter12")  
          sol.menu.start(map, igor_save_answer_menu_chapter_12, on_top)
          sol.timer.start(1000, function()
               if  good_answer_counter == 1 then
                hero:unfreeze()
                igor_chapter12_success = 1
                return false
               else 
                return true
              end
            end)
        end
      end)

   else

          game:start_dialog("outside_icarius_outH.chatty_bird_congratulation", function(answer) 
            chatty_bird:set_enabled(false)
            sol.audio.play_sound("secret")
            chest_flipper:set_enabled(true)
            game:set_value("flipper", true)
          end)         

    end
  
  else
 
    if game:get_value("chatty_bird_KO") then 

       game:start_dialog("outside_icarius_outH.chatty_bird_2", function(answer)
        if answer == 3 then 
          game:start_dialog("outside_icarius_outH.chatty_bird_KO")
        end
        if answer == 4 then
          game:start_dialog("outside_icarius_outH.chatty_bird_OK")
          game:set_value("chatty_bird_OK", true)
        end
      end)

    else

      game:start_dialog("outside_icarius_outH.chatty_bird_1", function(answer)
        if answer == 3 then 
          game:start_dialog("outside_icarius_outH.chatty_bird_KO")
          game:set_value("chatty_bird_KO", true)
        end
        if answer == 4 then
          game:start_dialog("outside_icarius_outH.chatty_bird_OK")
          game:set_value("chatty_bird_OK", true)
        end
      
      end)

    end

  end

end


function sensor_path_locked:on_activated()
      game:start_dialog("outside_icarius_outH.path_locked")
end

function sensor_ice_dungeon_exit:on_activated()
      game:start_dialog("outside_icarius_outH.frozen_exit")
end
