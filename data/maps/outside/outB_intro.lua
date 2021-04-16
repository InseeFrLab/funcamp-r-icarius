-- Kokoro village.

local map = ...
local game = map:get_game()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 2
 number_of_answers = 1
 good_answer_counter = 0

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


-- Unable Mage Tourep and Chest if quest already done
if game:get_value("kokoro_shield_quest") then
      shield_barrier:set_enabled(false)
      mage_tourep:set_enabled(false)
      kokoro_shield_chest:set_enabled(false)
end


local movement_welcome = sol.movement.create("random")
movement_welcome:set_speed(12)

function map:on_started()

  movement_welcome:start(welcome_npc)
  farm_external_door_1:set_enabled(true)
  farm_external_door_2:set_enabled(true)
end

function welcome_npc:on_interaction()
  movement_welcome:stop(welcome_npc)
end


local movement = sol.movement.create("straight")
movement:set_angle(math.pi / 2)
movement:set_speed(2)
movement:set_max_distance(24)

function soldier:on_interaction()

 if game:has_item("shield") then
  game:start_dialog("kokoro.soldier_with_shield")
  sol.audio.play_sound("secret")
  movement:start(soldier)
 else
  game:start_dialog("kokoro.soldier_without_shield")
 end

end


-- Interactions avec le fermier,
-- chapitre 2 d'IGoR

function farmer_2:on_interaction()

  if game:get_value("chapter2_answer") == nil then
    if game:get_value("kokoro_farmer_quest") then
      if game:get_value("kokoro_farmer_igor_chapter2") then
        game:start_dialog("kokoro.farmer_2_a_short", function(answer)
 
          if answer == 2 then
           hero:freeze()
           local save_answers_menu = file()
           sol.menu.start(map, save_answers_menu, on_top)
          end

        end)
      else
         game:start_dialog("kokoro.farmer_2_a", function(answer)    
          game:set_value("kokoro_farmer_igor_chapter2", true)
   
          if answer == 2 then
           hero:freeze()
           local save_answers_menu = file()
           sol.menu.start(map, save_answers_menu, on_top)
          end

         end)
      end
    else 
     game:start_dialog("kokoro.farmer_2_a_wife") 
    end
  elseif game:get_value("chapter2_answer") == true then
    game:start_dialog("kokoro.farmer_2_b")
    sol.timer.start(1000, function()      
      sol.audio.play_sound("door_open")
      farm_external_door_1:set_enabled(false)
      farm_external_door_2:set_enabled(false)
      sol.audio.play_music("village")
    end)
  end

end

-- Lorsque le héros apporte la bonne réponse
-- déblocage du personnage

sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
        hero:unfreeze()
    end)
    game:set_value("chapter2_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)



-- Interactions avec le Mage Tourep,
-- apparition du bouclier

function mage_tourep:on_interaction()

  if game:get_value("chapter2_answer") == nil then
    game:start_dialog("kokoro.mage_tourep")
  elseif game:get_value("chapter2_answer") == true then
    game:set_value("kokoro_shield_quest", true)
    game:start_dialog("kokoro.mage_tourep_OK")
    sol.timer.start(1000, function()      
      sol.audio.play_sound("secret")
      shield_barrier:set_enabled(false)
      mage_tourep:set_enabled(false)
    end)
  end

end

function house_door_close_1:on_interaction()
    
  game:start_dialog("kokoro.door_closed")

end


function house_door_close_2:on_interaction()
    
  game:start_dialog("kokoro.door_closed")

end
