local map = ...
local game = map:get_game()


-- Set dialogs with PNJ
function pnj2:on_interaction()
  
  if game:get_value("phocea_quest_pnj2") == nil then
     game:start_dialog("village_phocea.pnj2_1")
     game:set_value("phocea_quest_pnj2", true)
  else
      game:start_dialog("village_phocea.pnj2_2")
  end

end

