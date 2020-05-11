local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  if game:get_value("igor_chapter13_success") then

      sol.timer.start(2000, function()
        sol.audio.play_sound("secret")
        obstacle_1:set_enabled(false)
      end)

  end

end
