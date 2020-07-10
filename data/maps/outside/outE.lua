-- GrissGrass Village

local map = ...
local game = map:get_game()

-- Création de la table des bonnes réponses,
-- utilisée ensuite dans le menu igor_save_answer_chapter6 et igor_save_answer_chapter7
-- Initialisation à 0
good_answer_counter_chapter3 = {}
good_answer_counter_chapter3 = 0

good_answer_counter_chapter4 = {}
good_answer_counter_chapter4 = 0


function sensor_cimetiere:on_activated()
    game:start_dialog("village_grissgrass.cimetiere_sagesse")
    sensor_cimetiere:set_enabled(false)
end


function gardien_cimetiere:on_interaction()

   if game:get_value("grissgrass_elixir_mandragore") then
    game:start_dialog("village_grissgrass.gardien_cimetiere_ok")
    sol.timer.start(1000, function()   
      sol.audio.play_sound("secret")
      gardien_cimetiere:set_enabled(false)
    end)
   else
    game:start_dialog("village_grissgrass.gardien_cimetiere_ko")
   end

end