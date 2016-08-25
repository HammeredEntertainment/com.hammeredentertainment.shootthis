--
-- Created by IntelliJ IDEA.
-- User: BenjaminSchatter
-- Date: 24.08.16
-- Time: 12:44
-- To change this template use File | Settings | File Templates.
--

-- fireModes
-- 'fireMode = 1' :: single, player centered shot
-- 'fireMode = 2' :: double shots, located at the two front facing edges of the players image

weapon1 = {fireRate = 0.35, fireMode = 1, bulletImg = love.graphics.newImage("assets/bulletImg.png"), baseDamage = 110 }
weapon2 = {fireRate = 0.1, fireMode = 1, bulletImg = love.graphics.newImage("assets/bullet2Img.png"), baseDamage = 25 }
weapon3 = {fireRate = 0.05, fireMode = 2, bulletImg = love.graphics.newImage("assets/bullet3Img.png"), baseDamage = 15}

