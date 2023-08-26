local map = ...
local game = map:get_game()


-- Set dialogs with PNJ
function pnj1:on_interaction()
  
  if game:get_value("phocea_quest_pnj1") == nil then
     game:start_dialog("village_phocea.pnj1_1")
     game:set_value("phocea_quest_pnj1", true)
  else
      game:start_dialog("village_phocea.pnj1_2")
  end

end

