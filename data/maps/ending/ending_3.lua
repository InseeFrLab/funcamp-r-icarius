-- The end - Stats
local map = ...
local game = map:get_game()

local stats_manager = require("scripts/menus/stats")

function map:on_started()

  game:set_pause_allowed(false)
  game:set_hud_enabled(false)
  game:get_dialog_box():set_style("empty")
  game:get_dialog_box():set_position({ x = 8, y = 8})
end

function map:on_opening_transition_finished()
  hero:freeze()
    local stats = stats_manager:new(game)
    sol.menu.start(map, stats)
end


