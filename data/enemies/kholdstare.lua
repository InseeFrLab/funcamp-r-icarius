-- Kholdstare boss.

local enemy = ...

function enemy:on_created()

  enemy:set_life(24)
  enemy:set_damage(4)
  enemy:set_hurt_style("boss")
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
end

function enemy:on_restarted()

  local movement = sol.movement.create("target")
  movement:set_speed(48)
  movement:start(enemy)
end
