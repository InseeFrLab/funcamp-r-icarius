local map = ...
local game = map:get_game()

function fermier_1:on_interaction()
      game:start_dialog("village_grissgrass.fermier_1")
      game:set_value("grissgrass_quest_farmer_1", true)
end