local map = ...
local game = map:get_game()
-- Outside world C3

local fighting_boss = false
local arrows_timer

function map:on_started(destination)

  local new_music
  if destination == from_ending then
    -- game ending sequence
    hero:freeze()
    hero:set_visible(false)
    game:set_hud_enabled(false)
    map:set_entities_enabled("enemy", false)
    new_music = "fanfare"
    map:set_entities_enabled("roof_entrance", false)
  else
    -- enable dark world
    if game:get_value("b905") then
      new_music = "dark_mountain"
      map:set_tileset(13)
    else
      new_music = "overworld"
    end

    -- boss fight
    if destination == from_dungeon_10_5f then

      if not game:get_value("b299") then
	-- boss not killed yet
        new_music = nil
        map:set_entities_enabled("enemy", false) -- disable all simple enemies
      elseif not game:get_value("b298") then
	-- boss killed but sword not got yet
	local variant = 2
	if game:get_ability("sword") >= 2 then
	  -- the player already has the second one: give the third one instead
	  variant = 3
	end
	map:create_pickable{
	  treasure_name = "sword",
	  treasure_variant = variant,
	  treasure_savegame_variable = "b298",
	  x = 440,
	  y = 157,
	  layer = 1
	}
      end
    else
      map:set_entities_enabled("roof_entrance", false)
    end
  end

  if boss ~= nil then
    boss:set_enabled(false)
  end

  sol.audio.play_music(new_music)
end

function map:on_opening_transition_finished(destination)

  if destination == from_ending then
    game:start_dialog("credits_6", function()
      sol.timer.start(2000, function()
        hero:teleport(131, "from_ending")
      end)
    end)
    map:move_camera(440, 96, 20, function() end, 1e6)
  end
end

function map:on_obtaining_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    sol.audio.play_music("excalibur")
  end
end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    hero:start_victory(function()
      game:set_dungeon_finished(10)
      hero:teleport(119, "from_dungeon_10")
      map:set_entities_enabled("enemy", true) -- enable simple enemies back

      sol.timer.start(1000, function()
        if game:get_value("b905") then
          sol.audio.play_music("dark_mountain")
        else
          sol.audio.play_music("overworld")
        end
      end)
    end)
  end
end

