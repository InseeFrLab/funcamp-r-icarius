local map = ...
local game = map:get_game()
-- Outside extra world M

local fighting_boss = false
local arrows_timer

function map:on_started(destination)
  local new_music
  new_music = "overworld"
  sol.audio.play_music(new_music)
end


-- Set dialogs with PNJ
function chief_village:on_interaction()

  if game:get_value("phocea_quest_pnj1") == nil or game:get_value("phocea_quest_pnj2") == nil or game:get_value("phocea_quest_pnj3") == nil then     
    if game:get_value("phocea_quest") == nil then
       game:start_dialog("outside_icarius_outM_extra.chief_village_1")
       game:set_value("phocea_quest", true)
    else
       game:start_dialog("outside_icarius_outM_extra.chief_village_2")
    end
  else
    game:start_dialog("outside_icarius_outM_extra.chief_village_3")
  end

end