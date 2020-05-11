local map = ...
local game = map:get_game()

local price = 50
local secret_passage = 0

function secret_passage_npc:on_interaction()

  
  if secret_passage == 0 then
    game:start_dialog("village_sandia.secret_passage.offer", price, function(answer)
      if answer == 3 then
        if game:get_money() < price then
          game:start_dialog("not_enough_money")
        else
          game:start_dialog("village_sandia.secret_passage.yes", function()
            game:remove_money(price)
            sol.audio.play_sound("secret")
            secret_passage_tile:remove()
            secret_passage_npc:remove()
          end)
        end
      end
    end)
  end
end
