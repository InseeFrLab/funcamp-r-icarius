local map = ...
local game = map:get_game()

local night_overlay = sol.surface.create(map:get_size())
local alpha = 192
night_overlay:fill_color({0, 0, 64, alpha})

-- Global variable set up to keep track of good answers
good_answer_table = {}

function map:on_started(destination)

  if destination ~= from_intro then
    snores:remove()
    night_overlay:clear()  -- No night.
    return
  end

  -- The intro scene is playing.
  -- Let the hero sleep for two second.
  game:set_pause_allowed(false)
  snores:get_sprite():set_ignore_suspend(true)
  bed:get_sprite():set_animation("hero_sleeping")
  hero:freeze()
  hero:set_visible(false)
  sol.timer.start(map, 2000, function()
    -- Show Statia's message.
    game:start_dialog("icarius_house.statia_message", function()
      sol.timer.start(map, 1000, function()
        -- Wake up.
        snores:remove()
        bed:get_sprite():set_animation("hero_waking")
        sol.timer.start(map, 500, function()
          -- Jump from the bed.
          hero:set_visible(true)
          hero:start_jumping(0, 24, true)
          game:set_pause_allowed(true)
          game:set_hud_enabled(true)
          bed:get_sprite():set_animation("empty_open")
          sol.audio.play_sound("hero_lands")

          -- Start the savegame from outside the bed next time.
          game:set_starting_location(map:get_id(), "from_savegame")

          -- Make the sun rise.
          sol.timer.start(map, 20, function()
            alpha = alpha - 1
            if alpha <= 0 then
              alpha = 0
            end
            night_overlay:clear()
            night_overlay:fill_color({0, 0, 64, alpha})

            -- Continue the timer if there is still night.
            return alpha > 0
          end)

        end)
      end)
    end)
  end)
end

function mage_zilap:on_interaction()

  if game:get_value("icarius_house_quest_igor_book") then 
    if game:get_value("icarius_house_igor_book_chest") then
      game:start_dialog("icarius_house.mage_zilap_bravo") 
    else
       game:start_dialog("icarius_house.mage_zilap_livre")
    end
  else
    game:start_dialog("icarius_house.mage_zilap_message", function(answer)
      if answer == 2 then 
        game:start_dialog("icarius_house.mage_zilap_colere")
      end
      if answer == 3 then
        game:start_dialog("icarius_house.mage_zilap_depit")
      end
    game:set_value("icarius_house_quest_igor_book", true)
    end)
  end
end

-- Launch the answer screen on interaction

function mage_dregor:on_interaction()

  if game:get_value("icarius_house_igor_book_chest") then
    if game:get_value("icarius_house_igor_chapter1") then
      game:start_dialog("icarius_house.mage_dregor_answer_short", function(answer)
        if answer == 2 then
          local igor_save_answer_menu_chapter_1 = require("scripts/menus/igor_save_answer_chapter1")  
          sol.menu.start(map, igor_save_answer_menu_chapter_1, on_top)
        end
      end)
    else
       game:start_dialog("icarius_house.mage_dregor_answer", function(answer)    
        game:set_value("icarius_house_igor_chapter1", true)
        if answer == 2 then
          local igor_save_answer_menu_chapter_1 = require("scripts/menus/igor_save_answer_chapter1")  
          sol.menu.start(map, igor_save_answer_menu_chapter_1, on_top)
        end
     end)
    end
  else 
   game:start_dialog("icarius_house.mage_dregor_runes") 
  end

end

-- Open the locked door

sol.timer.start(5000, function()
  if good_answer_counter == 1 then
    map:open_doors("door_a")
    sol.audio.play_sound("door_open")
    -- reset counter to zero
    good_answer_counter = 0
  else 
  return true  -- Repeat the timer.
  end
end)


-- Show the night overlay.
function map:on_draw(dst_surface)

  night_overlay:draw(dst_surface)
end

