local map = ...
local game = map:get_game()
local igor_chapter13_success = 0


function frog:on_interaction()

  if igor_chapter13_success == 0 then

      if game:get_value("igor_chapter13") then

        hero:freeze()

        game:start_dialog("tiny_house.frog_2", function(answer)

          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter13")  
            sol.menu.start(map, igor_save_answer_menu, on_top)         
            sol.timer.start(1000, function()
               if  good_answer_counter == 1 then
                hero:unfreeze()
                igor_chapter13_success = 1
                return false
               else 
                return true
              end
            end)
          end

          if answer == 3 then
            hero:unfreeze()
          end

        end)

      else
        game:start_dialog("tiny_house.frog_1", function(answer)    
          game:set_value("igor_chapter13", true)
        end)
      end

  else

    game:start_dialog("tiny_house.frog_3")
    game:set_value("igor_chapter13_success", true)

  end

end

