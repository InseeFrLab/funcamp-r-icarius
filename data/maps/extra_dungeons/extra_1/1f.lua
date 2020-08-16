local map = ...
local game = map:get_game()

local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

function map:on_opening_transition_finished(destination)

  if destination == start then
    game:start_dialog("extra_dungeons.extra_1.welcome")
  end

end

