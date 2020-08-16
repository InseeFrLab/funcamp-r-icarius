-- Outside H: Lake
local map = ...
local game = map:get_game()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 12
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


function chatty_bird:on_interaction()

  if game:get_value("chatty_bird_OK") then 

      game:start_dialog("outside_icarius_outH.chatty_bird_answer", function(answer)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
      end)

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


-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
      game:start_dialog("outside_icarius_outH.chatty_bird_congratulation", function(answer) 
        chatty_bird:set_enabled(false)
        sol.audio.play_sound("secret")
        chest_flipper:set_enabled(true)
        game:set_value("flipper", true)
        hero:unfreeze()
      end)   
    end)
    -- reset counter to zero
    game:set_value("chapter12_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)
  

function sensor_path_locked:on_activated()
      game:start_dialog("outside_icarius_outH.path_locked")
end

function sensor_ice_dungeon_exit:on_activated()
      game:start_dialog("outside_icarius_outH.frozen_exit")
end
