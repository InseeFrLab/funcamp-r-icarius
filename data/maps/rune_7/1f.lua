local map = ...
local game = map:get_game()

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

royal_emblem:set_visible(false)
rune_1:set_visible(false)
rune_2:set_visible(false)
rune_3:set_visible(false)
rune_4:set_visible(false)
rune_5:set_visible(false)
rune_6:set_visible(false)


function map:on_opening_transition_finished(destination)

  if destination == from_outside then
    game:start_dialog("rune_final.welcome")
  end
  music = sol.audio.get_music()

end

function talk_statia:on_activated()

    game:start_dialog("rune_final.statia_1")
    talk_statia:set_enabled(false)
    sol.timer.start(map, 2000, function()
      royal_emblem:set_visible(true)
      sol.audio.play_sound("secret")
      sensor_open_door:set_enabled(true)
    end)
end

function sensor_open_door:on_activated()

    game:start_dialog("rune_final.opening_boss_door", function()
      map:set_doors_open("auto_door_rune_a", true)
      map:set_doors_open("auto_door_rune_b", true)
    end)

end

local fighting_boss = false

function map:on_started()

  if boss ~= nil then
    boss:set_enabled(false)
  end
  map:set_doors_open("boss_door", true)
end

function start_boss_sensor:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      game:start_dialog("rune_final.pre_boss")
      hero:unfreeze()
      sol.audio.play_music("boss")
      fighting_boss = true
    end)
  end
end

if boss ~= nil then
  function boss:on_dead()
    fighting_boss = false
    map:open_doors("boss_door")
    sol.audio.play_music(music)
  end
end

function map:on_obtaining_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    -- Also give an additional heart container.
    game:add_max_life(2)
    game:set_life(game:get_max_life())
  end
end


local bombx, bomby, bombl = map:get_entity("prison_door_1"):get_position()

function sensor_prison_door_1:on_activated()
    game:set_hud_enabled(false)
    game:start_dialog("rune_final.opening_prison_door")
    sensor_prison_door_1:set_enabled(false)
    
    hero:walk("44444444444444446", false)

      sol.timer.start(2000, function()
        hero:freeze()
        sol.audio.play_sound("secret")
        rune_1:set_visible(true)
        sol.timer.start(1000, function()
          rune_2:set_visible(true)
          sol.timer.start(1000, function()
            rune_3:set_visible(true)
            sol.timer.start(1000, function()
              rune_4:set_visible(true)
              sol.timer.start(1000, function()
                rune_5:set_visible(true)
                sol.timer.start(1000, function()
                  rune_6:set_visible(true)
                  
                hero:start_victory(function()
                      map:create_explosion({x = bombx, y = bomby, layer = bombl, })
                      sol.audio.play_sound("bomb")
                      sol.timer.start(1000, function()
                              sol.audio.play_sound("secret")
                              map:open_doors("prison_door")
                              hero:unfreeze()
                      end)
                  end)

                end)
              end)
            end)
          end)
        end)
      end)
    
end

local movement_welcome = sol.movement.create("path")
movement_welcome:set_path{4,4,4,4,4,4,4,4,4,4,4,4}
movement_welcome:set_speed(48)

local night_overlay = sol.surface.create(map:get_size())
local alpha = 0
night_overlay:fill_color({0, 0, 64, alpha})

function sensor_prison_door_2:on_activated()

    sol.audio.stop_music()
    sol.audio.play_music("triforce")
    sensor_prison_door_2:set_enabled(false)
    hero:freeze()

    sol.timer.start(1000, function()

      movement_welcome:start(statia, function()

        game:start_dialog("rune_final.statia_2", function()

          -- freeze the hero
          hero:freeze()

          -- when dialog ended, make the map darker and darker
          sol.timer.start(map, 20, function()
            alpha = alpha + 1
            if alpha >= 192 then
              
              alpha = 192    
              -- when screen is dark,      
              -- move hero to the end of game
              hero:teleport("ending/ending_1", "start")

            end
            night_overlay:clear()
            night_overlay:fill_color({0, 0, 64, alpha})

            -- Continue the timer if there is still light.
            return alpha < 192
          end)

       end)

      end)
    end)

end


