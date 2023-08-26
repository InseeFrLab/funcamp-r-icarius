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

function chief_village:on_interaction()
  game:start_dialog("outside_icarius_outM_extra.chief_village_1") 
end
