-- Statistics screen about completing the game.

local stats_manager = { }

local gui_designer = require("scripts/menus/lib/gui_designer")

function stats_manager:new(game)

  local stats = {}

  local layout
  local tree_img = sol.surface.create("menus/tree_repeatable.png")
  local death_count
  local num_pieces_of_heart
  local max_pieces_of_heart
  local percent
  local tr = sol.language.get_string

  local function get_game_time_string()
    return tr("stats_menu.game_time") .. " " .. game:get_time_played_string()
  end

  local function get_death_count_string()
    death_count = game:get_value("death_count") or 0
    return tr("stats_menu.death_count"):gsub("%$v", death_count)
  end

  local function get_extra_parts_string()

    num_extras = 0
    for _, extras in ipairs({
      "dungeon_11_finished",
      "dungeon_12_finished",
      "dungeon_13_finished",
      "mode_pacman",
      "possession_magic_medallion",
    }) do
      if game:get_value(extras) then
        num_extras = num_extras + 1
      end
    end
    return tr("stats_menu.extras") .. " " .. num_extras .. " / "  ..5

  end


  local function get_pieces_of_heart_string()
    local item = game:get_item("piece_of_heart")
    num_pieces_of_heart = item:get_total_pieces_of_heart()
    max_pieces_of_heart = item:get_max_pieces_of_heart()
    return tr("stats_menu.pieces_of_heart") .. " "  ..
        num_pieces_of_heart .. " / " .. max_pieces_of_heart
  end


  local function get_percent_string()

    percent = 73
    num_extras = 0

    for _, extras in ipairs({
      "dungeon_11_finished",
      "dungeon_12_finished",
      "dungeon_13_finished",
      "mode_pacman",
      "possession_magic_medallion",
    }) do
      if game:get_value(extras) then
        num_extras = num_extras + 1
      end
    end

    -- Percentage of game finished = 73% when killing final boss + 1% per hidden piece of heart + 3% per optional world
    percent = percent + num_pieces_of_heart*1 + num_extras*3
    return tr("stats_menu.percent"):gsub("%$v", percent)
  end

  local function compute_skill_rank()

    local rank
    if death_count == 0 and
        percent == 100 then
      rank = tr("stats_menu.rank.ultimate")
    elseif percent == 100 then
      rank = tr("stats_menu.rank.completion.1")
    elseif percent > 90 then
      rank = tr("stats_menu.rank.completion.2")
    elseif percent > 85 then
      rank = tr("stats_menu.rank.completion.3")
    elseif percent > 80 then
      rank = tr("stats_menu.rank.completion.4")
    elseif percent > 75 then
      rank = tr("stats_menu.rank.completion.5")
    else
      rank = tr("stats_menu.rank.completion.6")
    end
    if rank == nil then
      return ""
    end
    return "- " .. rank
  end

  local function compute_speed_rank()

    local time_played = game:get_time_played()
    local rank
    if time_played <= 3600 then
      rank = tr("stats_menu.rank.speed.1")
    elseif time_played <= 4800 then
      rank = tr("stats_menu.rank.speed.2")
    else
      rank = tr("stats_menu.rank.speed.3")
    end

    if rank == nil then
      return ""
    end
    return "- " .. rank
  end

  local function build_layout(page)

    layout = gui_designer:create(320, 240)
    layout:make_tiled_image(tree_img)

    local y = 11
    layout:make_text(tr("stats_menu.title"), 160, y, "center")
    local x = 11
    y = y + 20
    layout:make_text(get_game_time_string(), x, y)
    y = y + 20
    layout:make_text(get_death_count_string(), x, y)
    y = y + 20
    layout:make_text(get_pieces_of_heart_string(), x, y)
    y = y + 20
    layout:make_text(get_extra_parts_string(), x, y)     
    y = y + 20
    layout:make_text(get_percent_string(), x, y)

    y = 170
    layout:make_text(tr("stats_menu.rank"), x, y)
    x = 59
    layout:make_text(compute_skill_rank(), x, y)
    y = y + 20
    layout:make_text(compute_speed_rank(), x, y)
  end

  build_layout(page)

  function stats:on_command_pressed(command)

    local handled = false
    if command == "action" then
      sol.main.reset()
      return true
    end
    return handled
  end

  function stats:on_draw(dst_surface)

    layout:draw(dst_surface)
  end

  return stats
end

return stats_manager
