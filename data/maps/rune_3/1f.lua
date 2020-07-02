local map = ...
local game = map:get_game()

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

local igor_chapter5_success = 0
local igor_chapter6_success = 0

function map:on_opening_transition_finished(destination)

  if destination == from_outside then
    game:start_dialog("rune_3.welcome")
  end
end


function sensor_throne_room_1:on_activated()
    game:start_dialog("castle.sensor_throne_room_1")
    sensor_throne_room_1:set_enabled(false)
end

function sensor_throne_room_2:on_activated()
    game:start_dialog("castle.sensor_throne_room_2")
    sensor_throne_room_2:set_enabled(false)
end

function sensor_throne_room_3:on_activated()
    game:start_dialog("castle.sensor_throne_room_3")
    sensor_throne_room_3:set_enabled(false)
end

function sensor_throne_room_4:on_activated()
    game:start_dialog("castle.sensor_throne_room_4")
    sensor_throne_room_4:set_enabled(false)
end

function sensor_throne_room_5:on_activated()
    game:start_dialog("castle.sensor_throne_room_5")
    sensor_throne_room_5:set_enabled(false)
end

function sensor_throne_room_6:on_activated()
    game:start_dialog("castle.sensor_throne_room_6")
    sensor_throne_room_6:set_enabled(false)
end

function sensor_throne_room_7:on_activated()
    game:start_dialog("castle.sensor_throne_room_7")
    sensor_throne_room_7:set_enabled(false)
end

function sensor_throne_room_8:on_activated()
    bad_spirit_1:set_enabled(true)
    bad_spirit_2:set_enabled(true)
    game:start_dialog("castle.sensor_throne_room_8")
    sensor_throne_room_8:set_enabled(false)
end

function sensor_throne_room_9:on_activated()
    game:start_dialog("castle.sensor_throne_room_9")
end


function chief_army:on_interaction()

    if game:get_value("fake_news_quest") then
      game:start_dialog("castle.chief_army_2", function()
        sol.timer.start(1000, function()
          sol.audio.play_sound("secret")
          chief_army:set_enabled(false)
          curtain:set_enabled(false)
        end)
      end) 
    else
     game:start_dialog("castle.chief_army_1", function()
      sol.timer.start(1000, function()
        map:open_doors("castle_door_a_1")
        map:open_doors("castle_door_a_2")
        sol.audio.play_sound("door_open")
      end)
     end) 
    end

end

function drunk_man:on_interaction()

  if igor_chapter5_success == 0 then

    if game:get_value("igor_chapter5") then

      hero:freeze()

      game:start_dialog("castle.drunk_man_2", function(answer)

         if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter5")  
            sol.menu.start(map, igor_save_answer_menu, on_top)         
            sol.timer.start(1000, function()
               if  good_answer_counter == 1 then
                hero:unfreeze()
                igor_chapter5_success = 1
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

      game:start_dialog("castle.drunk_man_1", function(answer)
      game:set_value("igor_chapter5", true)
      end) 

    end

  else

          game:start_dialog("castle.drunk_man_3")
          sol.timer.start(1000, function()      
            sol.audio.play_sound("secret")
            chest_drunk_man:set_enabled(true)
          end)

  end

end


function old_man:on_interaction()

  if igor_chapter6_success == 0 then

    if game:get_value("igor_chapter6") then

      hero:freeze()

      game:start_dialog("castle.old_man_2", function(answer)

         if answer == 2 then
            local igor_save_answer_menu = {}
            igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter6")  
            sol.menu.start(map, igor_save_answer_menu, on_top)         
            sol.timer.start(1000, function()
               if  good_answer_counter == 1 then
                hero:unfreeze()
                igor_chapter6_success = 1
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

      game:start_dialog("castle.old_man_1", function(answer)
      game:set_value("igor_chapter6", true)
      end) 

    end

  else

         game:start_dialog("castle.old_man_3")
          sol.timer.start(1000, function()   
            sol.audio.play_sound("bomb") 
            weak_wall:set_enabled(false)
            secret_door:set_enabled(false)
            game:set_value("fake_news_quest", true)
              sol.timer.start(1000, function() 
              sol.audio.play_sound("secret")
              old_man:set_enabled(false)
            end)
          end)

  end

end

