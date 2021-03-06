-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

local dialog_box_manager = require("scripts/dialog_box")
local hud_manager = require("scripts/hud/hud")
local pause_manager = require("scripts/menus/pause")
local dungeon_manager = require("scripts/dungeons")
local equipment_manager = require("scripts/equipment")
local camera_manager = require("scripts/camera_manager")

local game_manager = {}

-- Sets initial values for a new savegame of this quest.
local function initialize_new_savegame(game)
  game:set_starting_location("intro")
  game:set_max_money(999)
  game:set_max_life(6)
  game:set_life(game:get_max_life())
  game:set_value("force", 0)
  game:set_value("defense", 0)
  game:set_value("time_played", 0)
--  game:get_item("bombs_counter"):set_variant(1)
  game:set_value("keyboard_commands", "f1")
  game:set_value("keyboard_look", "left control")
  game:set_value("keyboard_map", "p")
  game:set_value("keyboard_monsters", "m")
  game:set_value("keyboard_run", "left shift")
  game:set_value("keyboard_save", "escape")
end

-- Updates values for an existing savegame of this quest.
local function initialize_existing_savegame(game)

  if game:get_value("keyboard_save") == nil then
    -- The savegame was created before 1.4.5,
    -- a lot of commands are now customizable.
    game:set_value("keyboard_commands", "f1")
    game:set_value("keyboard_map", "p")
    game:set_value("keyboard_monsters", "m")
    game:set_value("keyboard_save", "escape")
    game:set_value("keyboard_run", "left shift")
  end
end

-- Measures the time played in this savegame.
local function run_chronometer(game)

  local timer = sol.timer.start(game, 100, function()
    local time = game:get_value("time_played")
    time = time + 100
    game:set_value("time_played", time)
    return true  -- Repeat the timer.
  end)
  timer:set_suspended_with_map(false)
end

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Game constants.
  local normal_walking_speed = 96
  local fast_walking_speed = 192

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initialize_new_savegame(game)
  else
    initialize_existing_savegame(game)
  end

  local dialog_box
  local hud
  local pause_menu
  local previous_world
  local update_walking_speed

  -- Function called when the player runs this game.
  function game:on_started()

    dungeon_manager:create(game)
    equipment_manager:create(game)
    dialog_box = dialog_box_manager:create(game)
    hud = hud_manager:create(game)
    pause_menu = pause_manager:create(game)
    camera = camera_manager:create(game)

    -- Initialize the hero.
    local hero = game:get_hero()
    update_walking_speed()

    -- Measure the time played.
    run_chronometer(game)
  end

  -- Function called when the game stops.
  function game:on_finished()

    dialog_box:quit()
    dialog_box = nil
    hud:quit()
    hud = nil
    pause_menu = nil
    camera = nil
  end

  -- Changes the walking speed of the hero depending on whether
  -- run is pressed or caps lock is active.
  function update_walking_speed()

    local hero = game:get_hero()
    local speed = normal_walking_speed
    local modifiers = sol.input.get_key_modifiers()
    local keyboard_run_pressed = sol.input.is_key_pressed(game:get_value("keyboard_run")) or modifiers["caps lock"]
    local joypad_run_pressed = false
    local joypad_action = game:get_value("joypad_run")
    if joypad_action ~= nil then
      local button = joypad_action:match("^button (%d+)$")
      if button ~= nil then
        joypad_run_pressed = sol.input.is_joypad_button_pressed(button)
      end
    end
    if keyboard_run_pressed or
        joypad_run_pressed then
      speed = fast_walking_speed
    end
    if hero:get_walking_speed() ~= speed then
      hero:set_walking_speed(speed)
    end
  end

  -- Function called when the game is paused.
  function game:on_paused()

    -- Tell the HUD we are paused.
    hud:on_paused()

    -- Start the pause menu.
    sol.menu.start(game, pause_menu)
  end

  -- Function called when the game is paused.
  function game:on_unpaused()

    -- Tell the HUD we are no longer paused.
    hud:on_unpaused()

    -- Stop the pause menu.
    sol.menu.stop(pause_menu)
  end

  -- Function called when the player goes to another map.
  function game:on_map_changed(map)

    -- Notify the HUD (some HUD elements may want to know that).
    hud:on_map_changed(map)

    -- Reset torches info if the world changes.
    -- TODO the engine should have an event game:on_world_changed().
    local new_world = map:get_world()
    local world_changed = previous_world == nil or
        new_world == nil or
        new_world ~= previous_world
    if world_changed then
      game.lit_torches_by_map = nil  -- See entities/torch.lua
    end

    previous_world = new_world
  end

  -- Function called when the player presses a key during the game.
  function game:on_key_pressed(key)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding.
      return false
    end

    local handled = false
    if key == game:get_value("keyboard_run")
        or key == "caps lock" then
      -- Run.
      update_walking_speed()
      handled = true

    elseif game:is_pause_allowed() then  -- Keys below are menus.
      if key == game:get_value("keyboard_map") then
        -- Map.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("map")
          handled = true
        end

      elseif key == game:get_value("keyboard_monsters") then
        -- Monsters.
        if not game:is_suspended() or game:is_paused() then
          if game:has_item("monsters_encyclopedia") then
            game:switch_pause_menu("monsters")
            handled = true
          end
        end

      elseif key == game:get_value("keyboard_commands") then
        -- Commands.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("commands")
          handled = true
        end

      elseif key == game:get_value("keyboard_save") then
        if not game:is_paused() and
            not game:is_dialog_enabled() and
            game:get_life() > 0 then
          game:start_dialog("save_quit", function(answer)
            if answer == 2 then
              -- Continue.
              sol.audio.play_sound("danger")
            elseif answer == 3 then
              -- Save and quit.
              sol.audio.play_sound("quit")
              game:save()
              sol.main.reset()
            else
              -- Quit without saving.
              sol.audio.play_sound("quit")
              sol.main.reset()
            end
          end)
          handled = true
        end
      end
    end

    return handled
  end

  -- Function called when the player releases a key during the game.
  function game:on_key_released(key)

    local handled = false
    if key == game:get_value("keyboard_run")
        or key == "caps lock" then
      update_walking_speed()
      handled = true
    end

    return handled
  end

  -- Function called when the player presses a joypad button during the game.
  function game:on_joypad_button_pressed(button)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding.
      return false
    end

    local handled = false

    local joypad_action = "button " .. button
    if joypad_action == game:get_value("joypad_run") then
      -- Run.
      update_walking_speed()
      handled = true

    elseif game:is_pause_allowed() then  -- Keys below are menus.
      if joypad_action == game:get_value("joypad_map") then
        -- Map.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("map")
          handled = true
        end

      elseif joypad_action == game:get_value("joypad_monsters") then
        -- Monsters.
        if not game:is_suspended() or game:is_paused() then
          if game:has_item("monsters_encyclopedia") then
            game:switch_pause_menu("monsters")
            handled = true
          end
        end

      elseif joypad_action == game:get_value("joypad_commands") then
        -- Commands.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("commands")
          handled = true
        end

      elseif joypad_action == game:get_value("joypad_save") then
        if not game:is_paused() and
            not game:is_dialog_enabled() and
            game:get_life() > 0 then
          game:start_dialog("save_quit", function(answer)
            if answer == 2 then
              -- Continue.
              sol.audio.play_sound("danger")
            elseif answer == 3 then
              -- Save and quit.
              sol.audio.play_sound("quit")
              game:save()
              sol.main.reset()
            else
              -- Quit without saving.
              sol.audio.play_sound("quit")
              sol.main.reset()
            end
          end)
          handled = true
        end
      end
    end

    return handled
  end

  -- Function called when the player presses a joypad button during the game.
  function game:on_joypad_button_released(button)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding.
      return false
    end

    local handled = false

    local joypad_action = "button " .. button
    if joypad_action == game:get_value("joypad_run") then
      -- Stop running.
      update_walking_speed()
      handled = true
    end

    return handled
  end

  -- Game over animation.
  function game:on_game_over_started()
    sol.audio.play_sound("hero_dying")
    local map = game:get_map()
    local hero = game:get_hero()
    local death_count = game:get_value("death_count") or 0
    game.lit_torches_by_map = nil  -- See entities/torch.lua
    game:set_value("death_count", death_count + 1)
    hero:set_visible(false)
    local x, y, layer = hero:get_position()

    -- Use a fake hero entity for the animation because
    -- the one of the hero is suspended.
    local fake_hero = map:create_custom_entity({
      x = x,
      y = y,
      layer = layer,
      width = 16,
      height = 16,
      direction = 0,
      sprite = hero:get_tunic_sprite_id(),
    })
    fake_hero:get_sprite():set_animation("dying")
    fake_hero:get_sprite():set_ignore_suspend(true)  -- Cannot be done on the hero (yet).
    local timer = sol.timer.start(game, 3000, function()
      -- Restart the game.
      game:start()
    end)
  end

  function game:get_dialog_box()
    return dialog_box
  end

  -- Returns whether the HUD is currently shown.
  function game:is_hud_enabled()
    return hud:is_enabled()
  end

  -- Enables or disables the HUD.
  function game:set_hud_enabled(enable)
    return hud:set_enabled(enable)
  end

  -- Pauses the game with the specified pause submenu,
  -- or unpauses the game if this submenu is already active.
  function game:switch_pause_menu(submenu_name)
    pause_menu:switch_submenu(submenu_name)
  end

  -- Returns the game time in seconds.
  function game:get_time_played()
    local milliseconds = game:get_value("time_played")
    local total_seconds = math.floor(milliseconds / 1000)
    return total_seconds
  end

  -- Returns a string representation of the game time.
  function game:get_time_played_string()
    local total_seconds = game:get_time_played()
    local seconds = total_seconds % 60
    local total_minutes = math.floor(total_seconds / 60)
    local minutes = total_minutes % 60
    local total_hours = math.floor(total_minutes / 60)
    local time_string = string.format("%02d:%02d:%02d", total_hours, minutes, seconds)
    return time_string
  end

  return game
end

return game_manager

