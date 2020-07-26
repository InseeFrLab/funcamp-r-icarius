local solarus_logo_menu = {}

-- Called when the menu is started.
function solarus_logo_menu:on_started()
  -- Keep trace of the current step.
  self.step = 0

  -- Load images.
  self.logo_img_1 = sol.surface.create("menus/intro/Funcamp-Wall-1.png")
  self.logo_img_2 = sol.surface.create("menus/intro/Funcamp-Wall-2.png")
  self.logo_img_3 = sol.surface.create("menus/intro/Funcamp-Wall-3.png")
  self.logo_img_4 = sol.surface.create("menus/intro/Funcamp-Wall-4.png")

  -- Load subtitle
  self.text = sol.text_surface.create({
    font = "alttp",
    font_size = 10,
    color = {240, 200, 56},
    horizontal_alignment = "center",
    text = "Funcamp R - Prototype 0.9.5.3",
  })

  -- Start animation.
  self:step_1()
end

-- Draws this menu.
function solarus_logo_menu:on_draw(dst_surface)

  local dst_w, dst_h = dst_surface:get_size()
  
  -- Vignettes
  if self.step >= 1 then
    self.logo_img_1:draw(dst_surface,2,-100)
    self.logo_img_2:draw(dst_surface,82,-160)
    self.logo_img_3:draw(dst_surface,162,-220)
    self.logo_img_4:draw(dst_surface,242,-280)

  end

  -- Subtitle 
  if self.step >= 2 then
    self.text:draw(dst_surface, 160, 160)
  end

end


-- Vignettes
function solarus_logo_menu:step_1()

  self.step = 1

  local movement1 = sol.movement.create("straight")
  movement1:set_speed(64)
  movement1:set_angle(3 * math.pi / 2)
  movement1:set_max_distance(180)

  local movement2 = sol.movement.create("straight")
  movement2:set_speed(64)
  movement2:set_angle(3 * math.pi / 2)
  movement2:set_max_distance(240)

  local movement3 = sol.movement.create("straight")
  movement3:set_speed(64)
  movement3:set_angle(3 * math.pi / 2)
  movement3:set_max_distance(300)
  
  local movement4 = sol.movement.create("straight")
  movement4:set_speed(64)
  movement4:set_angle(3 * math.pi / 2)
  movement4:set_max_distance(360)


  movement1:start(self.logo_img_1)
  movement2:start(self.logo_img_2)
  movement3:start(self.logo_img_3)
  movement4:start(self.logo_img_4, function()
      self:step_2()
  end)

end


-- Final fade-out
function solarus_logo_menu:step_2()
  self.step = 2
    sol.audio.play_sound("secret")

  sol.timer.start(solarus_logo_menu, 2000, function()
      sol.menu.stop(solarus_logo_menu)
  end)

end


-- Return the menu to the caller.
return solarus_logo_menu
