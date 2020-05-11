----------------------------------
-- Save Answers selection screen.
----------------------------------

-- Set Chapter Number and Number of answers
-- so as to check answers from R tutorial
chapter_number = 13
number_of_answers = 1
good_answer_counter = 0

-- language has to be French
sol.language.set_language("fr")

-- specify fonts for dialogues

function sol.language.get_dialog_font()

  local font
    font = "la"
    size = 11

  return font, size

end

-- specify fonts for menus

function sol.language.get_menu_font()

  local font
    font = "minecraftia"
    size = 8

  return font, size

end



local save_answers_menu = {}
local last_joy_axis_move = { 0, 0 }



function save_answers_menu:on_started()

  -- Create all graphic objects.
  self.surface = sol.surface.create(320, 240)
  self.background_color = { 104, 144, 240 }
  self.background_img = sol.surface.create("menus/selection_menu_background.png")
  self.save_container_img = sol.surface.create("menus/selection_menu_save_container.png")
  self.option_container_img = sol.surface.create("menus/selection_menu_option_container.png")
  local dialog_font, dialog_font_size = sol.language.get_dialog_font()
  local menu_font, menu_font_size = sol.language.get_menu_font()
  self.option1_text = sol.text_surface.create{
    font = dialog_font,
    font_size = dialog_font_size,
  }
  self.option2_text = sol.text_surface.create{
    font = dialog_font,
    font_size = dialog_font_size,
  }
  self.title_text = sol.text_surface.create{
    horizontal_alignment = "center",
    font = menu_font,
    font_size = menu_font_size,
  }
  self.cursor_position = 1
  self.cursor_sprite = sol.sprite.create("menus/selection_menu_cursor")
  self.allow_cursor_move = true
  self.finished = false
  self.phase = nil

  -- Run the menu.
  self:read_answers()
  sol.audio.play_music("game_over")
  self:init_phase_select_answer()

  -- Show an opening transition.
  self.surface:fade_in()
end

function save_answers_menu:on_key_pressed(key)

  local handled = false
  if key == "escape" then
    -- Stop the program.
    handled = true
    sol.main.exit()
  elseif key == "right" then
    handled = self:direction_pressed(0)
  elseif key == "up" then
    handled = self:direction_pressed(2)
  elseif key == "left" then
    handled = self:direction_pressed(4)
  elseif key == "down" then
    handled = self:direction_pressed(6)
  elseif not self.finished then

    -- Phase-specific direction_pressed method.
    local method_name = "key_pressed_phase_" .. self.phase
    handled = self[method_name](self, key)
  end

  return handled
end


function save_answers_menu:on_joypad_button_pressed(button)

  local handled = true
  if not self.finished then
    -- Phase-specific joypad_button_pressed method.
    local method_name = "joypad_button_pressed_phase_" .. self.phase
    handled = self[method_name](self, button)
  else
    handled = false
  end

  return handled
end


function save_answers_menu:on_joypad_axis_moved(axis, state)

  -- Avoid move repetition
  local handled = last_joy_axis_move[axis % 2] == state
  last_joy_axis_move[axis % 2] = state

  if not handled then
    if axis % 2 == 0 then  -- Horizontal axis.
      if state > 0 then
        self:direction_pressed(0)
      elseif state < 0 then
        self:direction_pressed(4)
      end
    else  -- Vertical axis.
      if state > 0 then
        self:direction_pressed(6)
      elseif state < 0 then
        self:direction_pressed(2)
      end
    end
  end

  return handled
end


function save_answers_menu:on_joypad_hat_moved(hat, direction8)

  if direction8 ~= -1 then
    self:direction_pressed(direction8)
  end
end


function save_answers_menu:direction_pressed(direction8)

  local handled = true
  if self.allow_cursor_move and not self.finished then

    -- The cursor moves too much when using a joypad axis.
    self.allow_cursor_move = false
    sol.timer.start(self, 100, function()
      self.allow_cursor_move = true
    end)

    -- Phase-specific direction_pressed method.
    local method_name = "direction_pressed_phase_" .. self.phase
    handled = self[method_name](self, direction8)
  else
    handled = false
  end
end


function save_answers_menu:on_draw(dst_surface)

  -- Background color.
  self.surface:fill_color(self.background_color)

  -- Saveanswers container.
  self.background_img:draw(self.surface, 37, 38)
  self.title_text:draw(self.surface, 160, 54)

  -- Phase-specific draw method.
  local method_name = "draw_phase_" .. self.phase
  self[method_name](self)

  -- The menu makes 320*240 pixels, but dst_surface may be larger.
  local width, height = dst_surface:get_size()
  self.surface:draw(dst_surface, width / 2 - 160, height / 2 - 120)
end


function save_answers_menu:draw_savegame(slot_index)

  local slot = self.slots[slot_index]
  self.save_container_img:draw(self.surface, 57, 48 + slot_index * 27)
  slot.player_answer_text:draw(self.surface, 87, 61 + slot_index * 27)

  if slot.hearts_view ~= nil then
    slot.hearts_view:set_dst_position(168, 51 + slot_index * 27)
    slot.hearts_view:on_draw(self.surface)
  end
end

function save_answers_menu:draw_savegame_cursor()

  local x, y
  if self.cursor_position == 5 then
    x = 166
  else
    x = 58
  end
  if self.cursor_position < 4 then
    y = 49 + self.cursor_position * 27
  else
    y = 159
  end
  self.cursor_sprite:draw(self.surface, x, y)
end

function save_answers_menu:draw_savegame_number(slot_index)

  local slot = self.slots[slot_index]
  slot.number_img:draw(self.surface, 62, 53 + slot_index * 27)
end

function save_answers_menu:draw_bottom_buttons()

  local x
  local y = 158
  if self.option1_text:get_text():len() > 0 then
    x = 57
    self.option_container_img:draw(self.surface, x, y)
    self.option1_text:draw(self.surface, 90, 172)
  end
  if self.option2_text:get_text():len() > 0 then
    x = 165
    self.option_container_img:draw(self.surface, x, y)
    self.option2_text:draw(self.surface, 198, 172)
  end
end


-- !!!!!!!!!!!!!!!!!!!
-- FUNCTION READ_ANSWERS
-- !!!!!!!!!!!!!!!!!!!

local answer_dummy = 0  -- dummy variable indicating if an answer has been filled.

-- Définition d'une table pour les réponses
answer_table = {}  --mod

function save_answers_menu:read_answers()

  self.slots = {}
  local font, font_size = sol.language.get_dialog_font()
  for i = 1, number_of_answers do
    local slot = {}
    slot.number_img = sol.surface.create("menus/selection_menu_save" .. i .. ".png")
    slot.player_answer_text = sol.text_surface.create{
      font = font,
      font_size = font_size,
    }
    if answer_dummy == 0 then
      local name = "- " .. sol.language.get_string("selection_menu.empty") .. " -"
      slot.player_answer_text:set_text(name)
   end
    if answer_dummy > 0 then
      local answer_filled = answer_table[i]
      slot.player_answer_text:set_text(answer_filled)
    end
    self.slots[i] = slot
  end

  if good_answer_counter == 1 then
    igor_save_answer_menu = require("scripts/menus/igor_save_answer_chapter13")
    sol.timer.start(2000, function()
    sol.menu.stop(igor_save_answer_menu)
    end)
  end

end

-- !!!!!!!!!!!!!!!!!!!


function save_answers_menu:set_bottom_buttons(key1, key2)

  if key1 ~= nil then
    self.option1_text:set_text_key(key1)
  else
    self.option1_text:set_text("")
  end

  if key2 ~= nil then
    self.option2_text:set_text_key(key2)
  else
    self.option2_text:set_text("")
  end
end

-- Paramétrage des mouvements "up" du curseur selon le nombre de réponses
function save_answers_menu:move_cursor_up()

  sol.audio.play_sound("cursor")
  local cursor_position = self.cursor_position - 1
  if cursor_position == 0 then
    cursor_position = 4
  elseif cursor_position == 4 then 
    cursor_position = number_of_answers
  elseif cursor_position == 3 then
    cursor_position = number_of_answers
  end
  self:set_cursor_position(cursor_position)
end

-- Paramétrage des mouvements "down" du curseur selon le nombre de réponses
function save_answers_menu:move_cursor_down()

  sol.audio.play_sound("cursor")
  local cursor_position = self.cursor_position + 1

  if number_of_answers == 1 then
    if cursor_position == 2 or cursor_position == 3 then
    cursor_position = 4
    end
  end

  if number_of_answers == 2 then
    if cursor_position == 3 then
    cursor_position = 4
    end
  end

  if cursor_position >= 5 then
    cursor_position = 1
  end
  self:set_cursor_position(cursor_position)
end

-- Paramétrage des mouvements latéraux du curseur
function save_answers_menu:move_cursor_left_or_right()

  if self.cursor_position == 4 then
    sol.audio.play_sound("cursor")
    self:set_cursor_position(5)
  elseif self.cursor_position == 5 then
    sol.audio.play_sound("cursor")
    self:set_cursor_position(4)
  end
end


function save_answers_menu:set_cursor_position(cursor_position)
  self.cursor_position = cursor_position
  self.cursor_sprite:set_frame(0)  -- Restart the animation.
end


-----------------------------------
-- Phase "select an answer slot" --
-----------------------------------

function save_answers_menu:init_phase_select_answer()
  self.phase = "select_answer"
  self.title_text:set_text_key("selection_menu.phase.select_answer")
  self:set_bottom_buttons("selection_menu.erase", "selection_menu.valid")
  self.cursor_sprite:set_animation("blue")
end


function save_answers_menu:key_pressed_phase_select_answer(key)

  local handled = false
  if key == "space" or key == "return" then
    sol.audio.play_sound("ok")
    if self.cursor_position == 5 then
      -- The user chooses "Options".
    save_answers_menu:init_phase_check_answer_alt()
    elseif self.cursor_position == 4 then
      -- The user chooses "Erase".
    save_answers_menu:init_phase_delete_answer()
    else
      -- The user chooses a savegame.
      local slot = self.slots[self.cursor_position]
        -- It's a new savegame: choose the player's name.
        self:init_phase_choose_name()
    end
    handled = true
  end

  return handled
end

function save_answers_menu:joypad_button_pressed_phase_select_answer(button)

  return self:key_pressed_phase_select_answer("space")
end

function save_answers_menu:direction_pressed_phase_select_answer(direction8)

  local handled = true
  if direction8 == 6 then  -- Down.
    self:move_cursor_down()
  elseif direction8 == 2 then  -- Up.
    self:move_cursor_up()
  elseif direction8 == 0 or direction8 == 4 then  -- Right or Left.
    self:move_cursor_left_or_right()
  else
    handled = false
  end
  return handled
end

function save_answers_menu:draw_phase_select_answer()

  -- Savegame slots.
  for i = 1, number_of_answers do
    self:draw_savegame(i)
  end

  -- Bottom buttons.
  self:draw_bottom_buttons()

  -- Cursor.
  self:draw_savegame_cursor()

  -- Save numbers.
  for i = 1, number_of_answers do
    self:draw_savegame_number(i)
  end
end



------------------------------
-- Phase "ANSWER" --
------------------------------
function save_answers_menu:init_phase_choose_name()

  self.phase = "choose_name"
  self.title_text:set_text_key("selection_menu.phase.choose_name")
  self.cursor_sprite:set_animation("letters")
  self.player_answer = ""
  local font, font_size = sol.language.get_menu_font()
  self.player_answer_text = sol.text_surface.create{
    font = font,
    font_size = font_size,
  }
  self.letter_cursor = { x = 0, y = 0 }
  self.letters_img = sol.surface.create("menus/selection_menu_letters.png")
  self.name_arrow_sprite = sol.sprite.create("menus/arrow")
  self.name_arrow_sprite:set_direction(0)
  self.can_add_letter_player_answer = true
end

function save_answers_menu:key_pressed_phase_choose_name(key)

  local handled = false
  local finished = false
  if key == "return" then
    -- Directly validate the name.
    finished = self:validate_player_answer()
    handled = true

  elseif key == "space" or key == "c" then

    if self.can_add_letter_player_answer then
      -- Choose a letter
      finished = self:add_letter_player_answer()
      self.player_answer_text:set_text(self.player_answer)
      self.can_add_letter_player_answer = false
      sol.timer.start(self, 300, function()
        self.can_add_letter_player_answer = true
      end)
      handled = true
    end
  end

  if finished then
    self:init_phase_select_answer()
  end

  return handled
end

function save_answers_menu:joypad_button_pressed_phase_choose_name(button)

  return self:key_pressed_phase_choose_name("space")
end

function save_answers_menu:direction_pressed_phase_choose_name(direction8)

  local handled = true
  if direction8 == 0 then  -- Right.
    sol.audio.play_sound("cursor")
    self.letter_cursor.x = (self.letter_cursor.x + 1) % 13

  elseif direction8 == 2 then  -- Up.
    sol.audio.play_sound("cursor")
    self.letter_cursor.y = (self.letter_cursor.y + 4) % 5

  elseif direction8 == 4 then  -- Left.
    sol.audio.play_sound("cursor")
    self.letter_cursor.x = (self.letter_cursor.x + 12) % 13

  elseif direction8 == 6 then  -- Down.
    sol.audio.play_sound("cursor")
    self.letter_cursor.y = (self.letter_cursor.y + 1) % 5

  else
    handled = false
  end
  return handled
end

function save_answers_menu:draw_phase_choose_name()

  -- Letter cursor.
  self.cursor_sprite:draw(self.surface,
      51 + 16 * self.letter_cursor.x,
      93 + 18 * self.letter_cursor.y)

  -- Name and letters.
  self.name_arrow_sprite:draw(self.surface, 57, 76)
  self.player_answer_text:draw(self.surface, 67, 85)
  self.letters_img:draw(self.surface, 57, 98)
end

function save_answers_menu:add_letter_player_answer()

  local size = self.player_answer:len()
  local letter_cursor = self.letter_cursor
  local letter_to_add = nil
  local finished = false

  if letter_cursor.y == 0 then  -- Uppercase letter from A to M.
    letter_to_add = string.char(string.byte("A") + letter_cursor.x)

  elseif letter_cursor.y == 1 then  -- Uppercase letter from N to Z.
    letter_to_add = string.char(string.byte("N") + letter_cursor.x)

  elseif letter_cursor.y == 2 then  -- Lowercase letter from a to m.
    letter_to_add = string.char(string.byte("a") + letter_cursor.x)

  elseif letter_cursor.y == 3 then  -- Lowercase letter from n to z.
    letter_to_add = string.char(string.byte("n") + letter_cursor.x)

  elseif letter_cursor.y == 4 then  -- Digit or special command.
    if letter_cursor.x <= 9 then
      -- Digit.
      letter_to_add = string.char(string.byte("0") + letter_cursor.x)
    else
      -- Special command.

      if letter_cursor.x == 10 then  -- Remove the last letter.
        if size == 0 then
          sol.audio.play_sound("wrong")
        else
          sol.audio.play_sound("danger")
          self.player_answer = self.player_answer:sub(1, size - 1)
        end

      elseif letter_cursor.x == 11 then  -- Validate the choice.
        finished = self:validate_player_answer()

      elseif letter_cursor.x == 12 then  -- Cancel.
        sol.audio.play_sound("danger")
        finished = true
      end
    end
  end

  if letter_to_add ~= nil then
    -- A letter was selected.
    if size < 6 then
      sol.audio.play_sound("danger")
      self.player_answer = self.player_answer .. letter_to_add
    else
      sol.audio.play_sound("wrong")
    end
  end

  return finished
end

function save_answers_menu:validate_player_answer()

  if self.player_answer:len() == 0 then
    sol.audio.play_sound("wrong")
    return false
  end

  sol.audio.play_sound("ok")
  answer_dummy = 1
--  answer_dummy = self.cursor_position
--  name = self.player_answer
  answer_table[self.cursor_position] = self.player_answer

  local savegame = self.slots[self.cursor_position].savegame
  self:set_initial_values(savegame)
  self:read_answers()
  return true
end

function save_answers_menu:set_initial_values(savegame)
-- éléments supprimés
end

---------------------------
-- Phase "Delete answers" --
---------------------------

function save_answers_menu:init_phase_delete_answer()
  for i = 1, number_of_answers do
  answer_table[i] = ""
  end
  self:read_answers()
end

---------------------------
-- Phase "Check answers" --
---------------------------


for i = 1, number_of_answers do
    good_answer_table[i] = sol.language.get_string("igor_answers.chapter" .. chapter_number .. "_answer" .. i .. "")
end

function save_answers_menu:init_phase_check_answer_alt()

-- Définition d'une table pour les réponses
  for i = 1, number_of_answers do
    if answer_table[i] ~= "" 
    and answer_table[i] ~= "- " .. sol.language.get_string("selection_menu.empty") .. " -" 
    and answer_table[i] ~= "Bravo, bonne réponse" then
      if answer_table[i] == good_answer_table[i] then
      answer_table[i] = "Bravo, bonne réponse"
      good_answer_counter = 1
      sol.audio.stop_music("game_over")
      else
      answer_table[i] = "Raté..."
      good_answer_counter = 0
      end
    end
  end
  
self:read_answers()
end



return save_answers_menu