local map = ...
local game = map:get_game()

local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

function sensor_sword_cave:on_activated()

    game:start_dialog("medallion_cave.welcome")
    sensor_sword_cave:set_enabled(false)

end