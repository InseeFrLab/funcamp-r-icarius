local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 6,
  damage = 2,
  normal_speed = 24,
  faster_speed = 24,
}

behavior:create(enemy, properties)
