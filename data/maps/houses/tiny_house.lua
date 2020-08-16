local map = ...
local game = map:get_game()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 13
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


function frog:on_interaction()

      if game:get_value("igor_chapter13") then

        game:start_dialog("tiny_house.frog_2", function(answer)
          if answer == 2 then
            hero:freeze()
            local save_answers_menu = file()
            sol.menu.start(map, save_answers_menu, on_top)
          end
        end)

      else
        game:start_dialog("tiny_house.frog_1", function(answer)    
          game:set_value("igor_chapter13", true)
        end)
      end

end


-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
      game:start_dialog("tiny_house.frog_3")
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        frog:set_enabled(false)
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter13_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


-- Unable farmer if quest already done
if game:get_value("chapter13_answer") then
  frog:set_enabled(false)
end


