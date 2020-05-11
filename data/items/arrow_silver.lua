local item = ...
local game = item:get_game()

function item:on_created()

  item:set_shadow("small")
  item:set_can_disappear(true)
  item:set_brandish_when_picked(false)
end

function item:on_started()

  item:set_obtainable(self:get_game():has_item("bow_silver"))
end

function item:on_obtaining(variant, savegame_variable)

  -- Call the code of normal arrows (their counter is common).
  game:get_item("arrow"):on_obtaining(variant, savegame_variable)
end
