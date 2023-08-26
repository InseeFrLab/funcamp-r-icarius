local map = ...
local game = map:get_game()


-- Set dialogs with PNJ
function pnj3:on_interaction()
  
  if game:get_value("phocea_quest_pnj3") == nil then
     game:start_dialog("village_phocea.pnj3_1")
     game:set_value("phocea_quest_pnj3", true)
  else
      game:start_dialog("village_phocea.pnj3_2")
  end

end

