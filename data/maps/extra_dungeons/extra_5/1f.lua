local map = ...
local game = map:get_game()
-- extra_dungeon 5

local fighting_miniboss = false
local camera_back_start_timer = false


function map:on_started(destination)

  -- miniboss
  map:set_doors_open("stairs_door", true)
  map:set_doors_open("miniboss_door", true)
  if miniboss ~= nil then
    miniboss:set_enabled(false)
  end
end

function map:on_opening_transition_finished(destination)

  -- show the welcome message
  if destination == from_outside then
    game:start_dialog("extra_dungeons.extra_5.warning")
  end
end

function start_miniboss_sensor:on_activated()

  if not game:get_value("b92") and not fighting_miniboss then
    -- the miniboss is alive
    map:close_doors("miniboss_door")
    hero:freeze()
    sol.timer.start(1000, function()
      sol.audio.play_music("boss")
      miniboss:set_enabled(true)
      hero:unfreeze()
    end)
    fighting_miniboss = true
  end
end

if miniboss ~= nil then
  function miniboss:on_dead()

    sol.audio.play_music("light_world_dungeon")
    map:open_doors("miniboss_door")
  end
end


