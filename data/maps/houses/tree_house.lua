local map = ...
local game = map:get_game()

local night_overlay = sol.surface.create(map:get_size())
local alpha = 0
night_overlay:fill_color({0, 0, 64, alpha})


function map:on_started()

teleport_exit:set_enabled(false)
sensor_exit:set_enabled(true)

function sensor_exit:on_activated()
    game:start_dialog("tree_house.sensor_exit")
end


function redhat_guy:on_interaction()

  -- Reveal Boomerang Chest if Reproducible Way has been mastered
  if game:get_value("icarius_house_bis_igor_book_chest") then 

      game:start_dialog("tree_house.redhat_guy_2", function()
         sol.timer.start(1000, function()      
          sol.audio.play_sound("secret")
          chest_boomerang:set_enabled(true)
          sensor_exit:set_enabled(false)
          teleport_exit:set_enabled(true)

         end)
      end)

  -- Otherwise, send the hero backward from the very (alternative) beginning)
  else game:start_dialog("tree_house.redhat_guy_1", function()

          -- freeze the hero
          hero:freeze()

          -- when dialog ended, make the map darker and darker
          sol.timer.start(map, 20, function()
            alpha = alpha + 1
            if alpha >= 192 then
              
              alpha = 192    
              -- when screen is dark,      
              -- move hero back to the very beginning of the game
              hero:teleport("houses/icarius_house_bis", "from_intro")

            end
            night_overlay:clear()
            night_overlay:fill_color({0, 0, 64, alpha})

            -- Continue the timer if there is still light.
            return alpha < 192
          end)

      end)

    end

end


end

-- Show the night overlay.
function map:on_draw(dst_surface)
  night_overlay:draw(dst_surface)
end




