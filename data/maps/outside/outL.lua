

local map = ...
local game = map:get_game()


function map:on_opening_transition_finished()

  function sensor_tomb_1:on_activated()
      game:start_dialog("outside_icarius_outL.tomb_1")
  end


  function sensor_tomb_2:on_activated()
      game:start_dialog("outside_icarius_outL.tomb_2")
  end


  function sensor_tomb_3:on_activated()
      game:start_dialog("outside_icarius_outL.tomb_3")
  end

end

