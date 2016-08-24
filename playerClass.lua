--
-- Created by IntelliJ IDEA.
-- User: BenjaminSchatter
-- Date: 24.08.16
-- Time: 23:34
-- To change this template use File | Settings | File Templates.
--

playerImg = nil
playerDefault = { x = 220, y = 710, speed = 150, weapon = weapon1, img = nil}
canShoot = true
canShootTimerMax = 0.35
canShootTimer = canShootTimerMax
playerClass = {}

player = { x = playerDefault.x, y = playerDefault.y, weapon = playerDefault.weapon, speed = playerDefault.speed, img = playerDefault.img }

function playerClass:load(arg)
    player.img = love.graphics.newImage("assets/player.png")
end