-- Kokoro village.

local map = ...
local game = map:get_game()

-- Création de la table des bonnes réponses,
-- utilisée ensuite dans le menu igor_save_answer_chapter2
-- Initialisation à 0
good_answer_counter_chapter2 = {}
good_answer_counter_chapter2 = 0

local movement_welcome = sol.movement.create("target")
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

  if good_answer_counter_chapter2 == 0 then
    if game:get_value("kokoro_farmer_quest") then
      if game:get_value("kokoro_farmer_igor_chapter2") then
        game:start_dialog("kokoro.farmer_2_a_short", function(answer)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter2")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
        end)
      else
         game:start_dialog("kokoro.farmer_2_a", function(answer)    
          game:set_value("kokoro_farmer_igor_chapter2", true)
          if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter2")  
            sol.menu.start(map, igor_save_answer_menu, on_top)
          end
       end)
      end
    else 
     game:start_dialog("kokoro.farmer_2_a_wife") 
    end
  elseif good_answer_counter_chapter2 == 1 then
    game:start_dialog("kokoro.farmer_2_b")
    sol.timer.start(1000, function()      
      sol.audio.play_sound("door_open")
      farm_external_door_1:set_enabled(false)
      farm_external_door_2:set_enabled(false)
    end)
  end

end

-- Interactions avec le Mage Tourep,
-- apparition du bouclier

function mage_tourep:on_interaction()

  if good_answer_counter_chapter2 == 0 then
    game:start_dialog("kokoro.mage_tourep")
  elseif good_answer_counter_chapter2 == 1 then
    game:start_dialog("kokoro.mage_tourep_OK")
    sol.timer.start(1000, function()      
      sol.audio.play_sound("secret")
      shield_barrier:set_enabled(false)
    end)
  end

end

function house_door_close_1:on_interaction()
    
  game:start_dialog("kokoro.door_closed")

end



function house_door_close_2:on_interaction()
    
  game:start_dialog("kokoro.door_closed")

end
