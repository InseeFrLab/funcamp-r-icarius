-- Lua script of map outside/outC_extra.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

  sol.audio.play_music("dark_mountain")

end


function switch_crabes:on_activated()

    sol.timer.start(1000, function()      
      sol.audio.play_sound("door_open")
      door_north_1:set_enabled(false)
      door_north_2:set_enabled(false)
      door_south_1:set_enabled(false)
      door_south_2:set_enabled(false)
      sol.timer.start(5000, function() 
        sol.audio.play_sound("secret")
        hammer:set_enabled(false)
      end)
    end)

end


function mage_dregor:on_interaction()
  game:start_dialog("outside_icarius_outC_extra.mage_dregor", function(answer)    
          if answer == 3  then
            game:set_value("mode_pacman", true)
            sol.audio.play_sound("secret")
          end
  end)
end