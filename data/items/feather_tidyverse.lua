local item = ...
local game = item:get_game()

function item:on_created()

  item:set_savegame_variable("possession_feather_tidyverse")
  game:set_ability("lift", 2)

end
