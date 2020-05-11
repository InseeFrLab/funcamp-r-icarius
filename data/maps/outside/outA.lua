-- Outside OutA: Forest
local map = ...
local game = map:get_game()


function statia_princess:on_interaction()

  game:start_dialog("outside_icarius_outA.statia_princess") 
  sol.timer.start(500, function()
    sol.audio.play_sound("secret")
    statia_princess:remove()
  end)
end
