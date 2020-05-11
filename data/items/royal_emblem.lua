local item = ...

function item:on_created()

  item:set_sound_when_picked(nil)

end

function item:on_obtaining()

  force = 5
  variant = 3
  self:get_game():set_value("force", force)
  self:get_game():set_ability("sword", variant)

end