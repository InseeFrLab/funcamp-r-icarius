local map = ...
local game = map:get_game()

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

-- Loading Input Answer Menu
file = assert(sol.main.load_file("scripts/menus/save_answers_menu.lua"))


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
    sensor_throne_room_6:set_enabled(false)
end

function sensor_throne_room_6:on_activated()
    game:start_dialog("castle.sensor_throne_room_6")
    sensor_throne_room_6:set_enabled(false)
    sensor_throne_room_5:set_enabled(false)
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


function sensor_warpzone_curiosity:on_activated()
        game:start_dialog("castle.sensor_warpzone_curiosity")
end


function sensor_warpzone:on_activated()
        game:start_dialog("castle.sensor_warpzone")
        game:set_value("fair_sala_quest", true)
        sensor_warpzone:set_enabled(false)
        warp_zone_entry:set_enabled(false)
        sensor_warpzone_curiosity:set_enabled(false)
        curtain_uncuttable:set_enabled(true)
end

function message_teleport:on_activated()
        game:start_dialog("castle.teleport")
end


function chief_army:on_interaction()

    if game:get_value("fake_news_quest") then
      game:start_dialog("castle.chief_army_2", function()
        sol.timer.start(1000, function()
          sol.audio.play_sound("secret")
          chief_army:set_enabled(false)
          if game:get_value("fair_sala_quest") then
            curtain_uncuttable:set_enabled(false)
          else
          curtain:set_enabled(false)
          end
        end)
      end) 
    else
      if game:get_value("essespeus_quest") then
        game:start_dialog("castle.chief_army_1_bis")
      else
        game:start_dialog("castle.chief_army_1", function()
          sol.timer.start(1000, function()
            game:set_value("essespeus_quest", true)
            map:open_doors("castle_door_a_1")
            map:open_doors("castle_door_a_2")
            sol.audio.play_sound("door_open")
          end)
        end) 
      end
    end

end



function sala_fairy:on_interaction()

      game:start_dialog("castle.sala_fairy", function()
        sol.timer.start(1000, function()
          sol.audio.play_sound("secret")
          sala_fairy:set_enabled(false)
          chest_fairy_sala:set_enabled(true)
        end)
      end)

end





function drunk_man:on_interaction()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 5
 number_of_answers = 1
 good_answer_counter = 0

   if game:get_value("chapter5_answer") == nil then

    if game:get_value("igor_chapter5") then

      game:start_dialog("castle.drunk_man_2", function(answer)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
      end)

    else

      game:start_dialog("castle.drunk_man_1", function(answer)
        game:set_value("igor_chapter5", true)
      end) 

    end

  end

end

 
-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 then
    sol.timer.start(2000,function()
      game:start_dialog("castle.drunk_man_3")
      sol.timer.start(1000,function()
        hero:unfreeze()
        sol.audio.play_sound("secret")
        chest_drunk_man:set_enabled(true)
        sol.audio.play_music("castle")
        drunk_man:set_enabled(false)
      end)
    end)
    -- reset counter to zero
    game:set_value("chapter5_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


function old_man:on_interaction()

 -- Set Chapter Number and Number of answers
 -- so as to check answers from R tutorial
 chapter_number = 6
 number_of_answers = 1
 good_answer_counter = 0

   if game:get_value("chapter6_answer") == nil then

    if game:get_value("igor_chapter6") then

      game:start_dialog("castle.old_man_2", function(answer)
        if answer == 2 then
          hero:freeze()
          local save_answers_menu = file()
          sol.menu.start(map, save_answers_menu, on_top)
        end
      end)

    else

      game:start_dialog("castle.old_man_1", function(answer)
        game:set_value("igor_chapter6", true)
      end) 

    end

  end

end


-- Unfreeze hero and save tutorial status
sol.timer.start(2000, function()
  if good_answer_counter == 1 and game:get_value("igor_chapter6") == true then
    sol.timer.start(2000,function()
      game:start_dialog("castle.old_man_3")
          sol.timer.start(1000, function()   
            sol.audio.play_sound("bomb") 
            weak_wall:set_enabled(false)
            secret_door:set_enabled(false)
            game:set_value("fake_news_quest", true)
              hero:unfreeze()
              sol.timer.start(1000, function() 
              sol.audio.play_sound("secret")
              old_man:set_enabled(false)
              sol.audio.play_music("castle")           
            end)
          end)

    end)
    -- reset counter to zero
    game:set_value("chapter6_answer", true)
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)