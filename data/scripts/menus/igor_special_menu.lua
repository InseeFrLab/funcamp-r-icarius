local igor_special_menu = {}

local text = sol.text_surface.create({
  font = "alttp",
  horizontal_alignment = "center",
  text = "Princesse Chloé",
})

function igor_special_menu:on_started()
  sol.timer.start(2000, function()
    sol.audio.play_sound("danger")
    sol.menu.stop(igor_special_menu)
  end)
end

function igor_special_menu:on_draw(dst_surface)
  local width, height = dst_surface:get_size()
  text:draw(dst_surface, width /2, height / 2)

end



return igor_special_menu
