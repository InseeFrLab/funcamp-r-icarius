-- Farm.
local map = ...
local game = map:get_game()



function farmer_1:on_interaction()

    game:start_dialog("kokoro.farmer_1_a", function(answer)
      if answer == 3 then 
        game:start_dialog("kokoro.farmer_1_b_OK")
        game:set_value("kokoro_farmer_quest", true)
        map:open_doors("door_farmer")
      end
      if answer == 4 then
        game:start_dialog("kokoro.farmer_1_b_KO")
      end
    end)

end
