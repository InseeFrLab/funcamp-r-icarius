local options_manager = {}

local gui_designer = require("scripts/menus/lib/gui_designer")

local movement_speed = 800
local movement_distance = 160

local cursor_position = 1

local width, height = sol.video.get_quest_size()
local center_x, center_y = width / 2, height / 2


local function create_item_widget(game)
  
  local widget = gui_designer:create(240, 120)

  widget:set_xy(-120, 40)
  widget:make_green_frame()
  local items_surface = widget:get_surface()

  local font, font_size = "minecraftia", 8
  local text_color = { 255, 255, 255 }

  video_mode_label_text = sol.text_surface.create{
    horizontal_alignment = "left",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text_key = "pause.options.video_mode",
    color = text_color,
  }
  video_mode_label_text:set_xy(center_x - 80, center_y - 58)

  video_mode_text = sol.text_surface.create{
    horizontal_alignment = "right",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text = sol.video.get_mode(),
    color = text_color,
  }
  video_mode_text:set_xy(center_x + 60, center_y - 58)

  music_volume_label_text = sol.text_surface.create{
    horizontal_alignment = "left",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text_key = "pause.options.music_volume",
    color = text_color,
  }
  music_volume_label_text:set_xy(center_x - 80, center_y - 34)

  music_volume_text = sol.text_surface.create{
    horizontal_alignment = "right",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text = math.floor((sol.audio.get_music_volume() + 5) / 10) * 10,
    color = text_color,
  }
  music_volume_text:set_xy(center_x + 60, center_y - 34)

 sound_volume_label_text = sol.text_surface.create{
    horizontal_alignment = "left",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text_key = "pause.options.sound_volume",
    color = text_color,
  }
  sound_volume_label_text:set_xy(center_x - 80, center_y - 10)

  sound_volume_text = sol.text_surface.create{
    horizontal_alignment = "right",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text = math.floor((sol.audio.get_sound_volume() + 5) / 10) * 10,
    color = text_color,
  }
  sound_volume_text:set_xy(center_x + 60, center_y - 10)

  panel_label_text = sol.text_surface.create{
    horizontal_alignment = "left",
    vertical_alignment = "top",
    font = font,
    font_size = font_size,
    text_key = "pause.options.label",
    color = text_color,
  }
  panel_label_text:set_xy(center_x - 90, center_y + 20)

  cursor_img = sol.sprite.create("menus/arrow")
  cursor_img:set_animation("blinking")
  cursor_img:set_direction(0)
  cursor_img:set_xy(center_x - 90, center_y - 60)

  return widget
end



function options_manager:new(game)

  local options_box = {}

  local state = "opening"  -- "opening", "ready" or "closing".

  local item_widget = create_item_widget(game)

  -- Rapidly moves the options_box widgets towards or away from the screen.
  local function move_widgets(callback)

    local angle_added = 0
    if item_widget:get_xy() > 0 then
      -- Opposite direction when closing.
      angle_added = math.pi
    end

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(0 + angle_added)
    item_widget:start_movement(movement, callback)

  end


  function options_box:on_draw(dst_surface)

    item_widget:draw(dst_surface)
    video_mode_label_text:draw(dst_surface)
    video_mode_text:draw(dst_surface)
    music_volume_label_text:draw(dst_surface)
    music_volume_text:draw(dst_surface)
    sound_volume_label_text:draw(dst_surface)
    sound_volume_text:draw(dst_surface)
    panel_label_text:draw(dst_surface)
    cursor_img:draw(dst_surface)

  end

function set_cursor_position(index)

  cursor_position = index
  cursor_img:set_xy(center_x - 90, center_y - 60 + (index-1) * 24)

end

function options_box:on_key_pressed(key)

    local handled = false

    if key == "down" then
      if cursor_position < 3 then
        set_cursor_position(cursor_position + 1)
      else
        set_cursor_position(1)
      end
      sol.audio.play_sound("cursor")
      handled = true
    elseif key == "up" then
      if cursor_position > 1 then
        set_cursor_position(cursor_position - 1)
      else
        set_cursor_position(3)
      end
      sol.audio.play_sound("cursor")
      handled = true
    elseif key == "space" then
      sol.audio.play_sound("danger")
      if cursor_position == 1 then
        -- Change the video mode.
        sol.video.switch_mode()
        video_mode_text:set_text(sol.video.get_mode())
      elseif cursor_position == 2 then
         if sol.audio.get_music_volume() == 0 then
            sol.audio.set_music_volume(100)        
            music_volume_text:set_text(sol.audio.get_music_volume())
         else
           sol.audio.set_music_volume(sol.audio.get_music_volume()-10)        
           music_volume_text:set_text(sol.audio.get_music_volume())
         end
      else
        if sol.audio.get_sound_volume() == 0 then
            sol.audio.set_sound_volume(100)        
            sound_volume_text:set_text(sol.audio.get_sound_volume())
         else
           sol.audio.set_sound_volume(sol.audio.get_sound_volume()-10)        
           sound_volume_text:set_text(sol.audio.get_sound_volume())
         end
      end
      handled = true
    end

    return handled
 end


  function options_box:on_command_pressed(command)

    if state ~= "ready" then
      return true
    end

    local handled = false

    if command == "pause" then
      -- Close the pause menu.
      state = "closing"
      sol.audio.play_sound("pause_closed")
      move_widgets(function() game:set_paused(false) end)
      handled = true
    end

    return handled
  end

  move_widgets(function() state = "ready" end)

  return options_box
end


return options_manager