-- Arrghus boss.

local enemy = ...

function enemy:on_created()

  enemy:set_life(20)
  enemy:set_damage(4)
  enemy:set_hurt_style("boss")
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(true)
  enemy:set_obstacle_behavior("flying")
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)

  enemy:set_invincible()
  enemy:set_attack_consequence("sword", 0)
  enemy:set_attack_consequence("thrown_item", 1)
  enemy:set_arrow_reaction(1)
  enemy:set_hookshot_reaction(1)
end

function enemy:on_restarted()

  local movement = sol.movement.create("target")
  movement:set_speed(64)
  movement:start(enemy)
end
