local map = ...
local game = map:get_game()

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

local fighting_boss = false

function map:on_started()

  if boss ~= nil then
    boss:set_enabled(false)
  end
  map:set_doors_open("boss_door", true)
end

function map:on_opening_transition_finished(destination)

  if destination == from_outside then
    game:start_dialog("extra_dungeons.extra_2.welcome")
  end

end

function start_boss_sensor:on_activated()

  if boss ~= nil and not fighting_boss then
    hero:freeze()
    map:close_doors("boss_door")
    sol.audio.stop_music()
    sol.timer.start(1000, function()
      boss:set_enabled(true)
      boss:set_life(100)
      game:start_dialog("extra_dungeons.extra_2.warning")
      hero:unfreeze()
      sol.audio.play_music("boss")
      fighting_boss = true
    end)
  end

  local torch_prefix = "auto_torch_boss"
  local remaining = 0

  local function torch_on_lit()
    if remaining > 0 then
      remaining = remaining - 1
      if remaining == 0 then
      sol.audio.play_sound("secret")
      boss:set_invincible(false)
      game:start_dialog("extra_dungeons.extra_2.dying")
      boss:set_life(0)
      end
    end
  end

  local has_torches = false
  for torch in map:get_entities(torch_prefix) do
    if not torch:is_lit() then
      remaining = remaining + 1
    end
    torch.on_lit = torch_on_lit
    has_torches = true
  end
 -- if has_torches and remaining == 0 then
    -- All torches of this door are already lit.
  --  boss:set_life(0)
 -- end

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "tunic" then
    item:start_dungeon_finished_cutscene()
  end
end


