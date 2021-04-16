-- Outside OutA: Forest
local map = ...
local game = map:get_game()


-- Unable Princess if quest already done
if game:get_value("statia_princess_sword") then
  statia_princess:set_enabled(false)
end


function statia_princess:on_interaction()

  game:start_dialog("outside_icarius_outA.statia_princess")
  sol.timer.start(500, function()
    sol.audio.play_sound("secret")
    statia_princess:remove()
  end)
  game:set_value("statia_princess_sword", true)

end
