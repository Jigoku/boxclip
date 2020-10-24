particles = {}

particles.invincible = love.graphics.newParticleSystem(pickups.textures[5], 32)
particles.invincible:setParticleLifetime(2, 2) -- particle lifetime
particles.invincible:setEmissionRate(10)
particles.invincible:setSizeVariation(1)
particles.invincible:setLinearAcceleration(-400, -400, 400, 400) -- Random movement in all directions.
particles.invincible:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
particles.invincible:setSpin( 1, 5 )

return particles