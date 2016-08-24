--
-- Created by IntelliJ IDEA.
-- User: BenjaminSchatter
-- Date: 23.08.16
-- Time: 20:11
-- To change this template use File | Settings | File Templates.
--

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box

--debug.debug()

require("weapons")
require("powerUpClass")

powerUps = powerUpClass

isAlive = true
score = 0
playTimeDefault = 30 -- Playtime in seconds
start = 0

playerImg = nil
playerDefault = { x = 220, y = 710, speed = 150, weapon = weapon1, img = nil}
canShoot = true
canShootTimerMax = 0.35
canShootTimer = canShootTimerMax

bullets = {}

enemyImg = nil
createEnemyTimerMax = 1.0
createEnemyTimer = createEnemyTimerMax
enemies = {}

player = { x = playerDefault.x, y = playerDefault.y, weapon = playerDefault.weapon, speed = playerDefault.speed, img = playerDefault.img }

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end

function love.load(arg)
    player.img = love.graphics.newImage("assets/player.png")
    enemyImg = love.graphics.newImage("assets/enemy.png")
    enemyDamagedImg = love.graphics.newImage("assets/enemyDamaged.png")
    enemyDamagedHeavyImg = love.graphics.newImage("assets/enemyDamagedHeavy.png")
    powerUps:load()
    playTime = playTimeDefault
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    -- Start isAlive
    if isAlive == true then
        -- Test Weapon Switch Implementation // Needs to be removed
        if love.keyboard.isDown('1') then player.weapon = weapon1 end
        if love.keyboard.isDown('2') then player.weapon = weapon2 end
        --

        playTime = playTime - dt


        if love.keyboard.isDown('left','a') then
            if player.x > 0 then
                player.x = player.x - (player.speed*dt)
            end

        elseif love.keyboard.isDown('right','d') then
            if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
                player.x = player.x + (player.speed*dt)
            end

        end

        if love.keyboard.isDown('space') and canShoot then

            if player.weapon.fireMode == 1 then
                newBullet = { x = player.x + (player.img:getWidth()/2-player.weapon.bulletImg:getWidth()/2), y = player.y - player.weapon.bulletImg:getHeight(), img = player.weapon.bulletImg }
                canShootTimer = player.weapon.fireRate
            end

            -- Create some bullets

            table.insert(bullets, newBullet)
            canShoot = false

        end

        for i, bullet in ipairs(bullets) do
            bullet.y = bullet.y - (250*dt)
            if bullet.y < 0 then
                table.remove(bullets, i)
            end
        end

        canShootTimer = canShootTimer - (1*dt)
        if canShootTimer < 0 then
            canShoot = true
        end

        createEnemyTimer = createEnemyTimer - (1*dt)
        if createEnemyTimer < 0 then
            createEnemyTimer = createEnemyTimerMax

            -- Create an enemy
            randomNumber = math.random(enemyImg:getWidth(), love.graphics.getWidth() - enemyImg:getWidth())
            newEnemy = { x = randomNumber, y = -enemyImg:getHeight(), speed = 100, img = enemyImg, hitPoints = 100 }
            table.insert(enemies, newEnemy)
        end

        for i, enemy in ipairs(enemies) do
            enemy.y = enemy.y + (enemy.speed * dt)

            if enemy.y > 850 then
                table.remove(enemies, i)
            end
        end

        -- powerUps Update
        powerUps:update(dt)


        -- Collision detection, damage states and hitPoint management
        for i, enemy in ipairs(enemies) do
            for j, bullet in ipairs(bullets) do
                if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                    enemy.hitPoints = enemy.hitPoints - player.weapon.baseDamage
                    if enemy.hitPoints <= 50 and enemy.hitPoints > 25 then enemy.img = enemyDamagedImg end
                    if enemy.hitPoints <= 25 and enemy.hitPoints > 0 then enemy.img = enemyDamagedHeavyImg end

                    if enemy.hitPoints <= 0 then
                        table.remove(bullets, j)
                        table.remove(enemies, i)
                        score = score + 1
                    end
                    if enemy.hitPoints >0 then table.remove(bullets, j) end
                end
            end

            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight())
            and isAlive then
                table.remove(enemies, i)
                isAlive = false
            end
        end



        for i, enemy in ipairs(enemies) do
            if enemy.y > love.graphics.getHeight() then
                isAlive = false
            end

        end
        if playTime < 0 then isAlive = false end

    end

    -- END isAlive




    if not isAlive then -- remove all our bullets, powerUps and enemies from screen
    bullets = {}
    enemies = {}
    powerUps = {}
    end

    if not isAlive and love.keyboard.isDown('r') then


        -- reset timers
        canShootTimer = playerDefault.weapon.fireRate
        createEnemyTimer = createEnemyTimerMax

        -- move player back to default position
        player.x = playerDefault.x
        player.y = playerDefault.y
        player.weapon = playerDefault.weapon

        -- reset our game state
        score = 0
        isAlive = true
        playTime = playTimeDefault
        powerUps = powerUpClass
    end


end

function love.draw(dt)

    if isAlive and playTime > 0 then
        love.graphics.draw(player.img, player.x, player.y)
        love.graphics.print("Time left: " .. string.format("%i", playTime), love.graphics.getWidth()/2-30,0)

        for i, bullet in ipairs(bullets) do
            love.graphics.draw(bullet.img, bullet.x, bullet.y)
        end

        for i, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.x, enemy.y)
        end

        -- Include powerUps
        powerUps:draw(dt)

    else
        love.graphics.print("GAME OVER", love.graphics:getWidth()/2-30, love.graphics.getHeight()/2-40)
        love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    love.graphics.print("Score: " .. score, 0,0)
end