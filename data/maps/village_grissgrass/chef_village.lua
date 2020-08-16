local map = ...
local game = map:get_game()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 3
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))

-- Set dialogs with village chief
function chef_village:on_interaction()

  if game:get_value("chapter3_answer") == nil then
    if (game:get_value("grissgrass_quest") and game:get_value("grissgrass_quest_farmer_1") and game:get_value("grissgrass_quest_farmer_2")) then
      if game:get_value("grissgrass_igor_chapter3") then
        game:start_dialog("village_grissgrass.chef_village_2_a_short", function(answer)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
        end)
      else
         game:start_dialog("village_grissgrass.chef_village_2_a", function(answer)    
          game:set_value("grissgrass_igor_chapter3", true)
          if answer == 2 then
            hero:freeze()
            local save_answers_menu = file()
            sol.menu.start(map, save_answers_menu, on_top)
        end
       end)
      end
    else 
       game:start_dialog("village_grissgrass.chef_village_1")
       game:set_value("grissgrass_quest", true)
    end
  end

end

-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
      game:start_dialog("village_grissgrass.chef_village_2_b")
      game:set_value("grissgrass_quest_part2", true)
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        chef_village:set_enabled(false)
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter3_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


-- Unable village chief if quest already done
if game:get_value("chapter3_answer") then
  chef_village:set_enabled(false)
end
