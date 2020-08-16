-- The end.
local map = ...
local game = map:get_game()

local stats_manager = require("scripts/menus/stats")

--local background_img = sol.surface.create("menus/ending.png")

function map:on_started()

  game:set_pause_allowed(false)
  game:set_hud_enabled(false)
  game:get_dialog_box():set_style("empty")
  game:get_dialog_box():set_position({ x = 8, y = 8})
end


function map:on_opening_transition_finished()

  hero:freeze()
  embleme_rune:set_enabled(true)
  game:start_dialog("ending.ending_01", function()
        embleme_rune:set_enabled(false)
        soldier_chief:set_enabled(true)
        soldier_chief:get_sprite():set_ignore_suspend(true)
        soldier_1:get_sprite():set_ignore_suspend(true)
        soldier_2:get_sprite():set_ignore_suspend(true)
        soldier_3:get_sprite():set_ignore_suspend(true)
        soldier_4:get_sprite():set_ignore_suspend(true)
        soldier_5:get_sprite():set_ignore_suspend(true)
        soldier_6:get_sprite():set_ignore_suspend(true)
        soldier_1:set_enabled(true)
        soldier_2:set_enabled(true)
        soldier_3:set_enabled(true)
        soldier_4:set_enabled(true)
        soldier_5:set_enabled(true)
        soldier_6:set_enabled(true)

        sol.timer.start(2000, function()
        game:start_dialog("ending.ending_02", function()
            soldier_chief:set_enabled(false)
            soldier_1:set_enabled(false)
            soldier_2:set_enabled(false)
            soldier_3:set_enabled(false)
            soldier_4:set_enabled(false)
            soldier_5:set_enabled(false)
            soldier_6:set_enabled(false)
            sassos:set_enabled(true)

             sol.timer.start(2000, function() 
             game:start_dialog("ending.ending_03", function()
             sassos:set_enabled(false)
             statia:set_enabled(true) 
             tower_01:set_enabled(true) 
             tower_green_01:set_enabled(true) 
             tower_02:set_enabled(true) 
             tower_green_02:set_enabled(true) 

                sol.timer.start(2000, function() 
                game:start_dialog("ending.ending_04", function()
                statia:set_enabled(false)
                tower_01:set_enabled(false) 
                tower_green_01:set_enabled(false) 
                tower_02:set_enabled(false) 
                tower_green_02:set_enabled(false) 
                essespeus:set_enabled(true) 

                   sol.timer.start(2000, function() 
                   game:start_dialog("ending.ending_05", function()
                   essespeus:set_enabled(false)
                   zilap:set_enabled(true) 
                   regor:set_enabled(true) 
                   tourep:set_enabled(true) 


                      sol.timer.start(2000, function() 
                      game:start_dialog("ending.ending_06", function()
                      batreb:set_enabled(true) 
                      table_01:set_enabled(true)
                      table_02:set_enabled(true)
                      table_03:set_enabled(true)
                      table_04:set_enabled(true)
                      table_05:set_enabled(true)
                      table_06:set_enabled(true)
                      table_07:set_enabled(true)
                      table_08:set_enabled(true)
                      table_09:set_enabled(true)
                      ambroisie_1:set_enabled(true)
                      ambroisie_2:set_enabled(true)
                      ambroisie_3:set_enabled(true)

                        sol.timer.start(2000, function() 
                        game:start_dialog("ending.ending_07", function()
                        zilap:set_enabled(false)
                        regor:set_enabled(false) 
                        tourep:set_enabled(false) 
                        batreb:set_enabled(false)
                        table_01:set_enabled(false)
                        table_02:set_enabled(false)
                        table_03:set_enabled(false)
                        table_04:set_enabled(false)
                        table_05:set_enabled(false)
                        table_06:set_enabled(false)
                        table_07:set_enabled(false)
                        table_08:set_enabled(false)
                        table_09:set_enabled(false)
                        ambroisie_1:set_enabled(false)
                        ambroisie_2:set_enabled(false)
                        ambroisie_3:set_enabled(false)
                        teoc:set_enabled(true) 

                          sol.timer.start(2000, function() 
                          game:start_dialog("ending.ending_08", function()
                          teoc:set_enabled(false)
                          febeler:set_enabled(true) 

                            sol.timer.start(2000, function() 
                            game:start_dialog("ending.ending_09", function()
                            febeler:set_enabled(false)

                              sol.timer.start(2000, function() 
                              game:start_dialog("ending.ending_10", function()
                              hero:teleport("ending/ending_2", "start")
                              end)
                              end)

                            end)
                            end)

                          end)
                          end)

                        end)
                        end)

                      end)
                      end)

                    end)
                    end)

                  end)
                  end)

                end)
                end)

             end)
             end)

   end)


end

