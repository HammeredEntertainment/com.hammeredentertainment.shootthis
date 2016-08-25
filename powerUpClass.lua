--
-- Created by IntelliJ IDEA.
-- User: BenjaminSchatter
-- Date: 24.08.16
-- Time: 18:17
-- To change this template use File | Settings | File Templates.
--
powerUpImg = nil
createPowerUpTimerMax = 3.0
createPowerUpTimer = createPowerUpTimerMax
powerUpClass = {}
powerUpActive = false

speedDoublePowerUp = {x = nil, y = nil, speedMultiplier = 2.0, speed = 200, spawnChance = 0.01, img = love.graphics.newImage("assets/speedDoublePowerUp.png")}

function powerUpClass:load()
    powerUpImg = speedDoublePowerUp.img
end

function powerUpClass:update(dt)
    -- Create a PowerUp
    createPowerUpTimer = createPowerUpTimer - (1*dt)
    if createPowerUpTimer < 0 and math.random(0,100) <= 100/speedDoublePowerUp.spawnChance then
        createPowerUpTimer = createPowerUpTimerMax

        -- Create an powerUp
        randomNumber = math.random(powerUpImg:getWidth(), love.graphics.getWidth() - powerUpImg:getWidth())
        newPowerUp = { x = randomNumber, y = -powerUpImg:getHeight(), speed = 100, img = powerUpImg, hitPoints = 100}
        table.insert(powerUps, newPowerUp)
    end

    for i, powerUp in ipairs(powerUps) do
        powerUp.y = powerUp.y + (powerUp.speed * dt)

        if powerUp.y > 850 then
            table.remove(powerUps, i)
        end
    end

    --    -- Create PowerUps
    --    randomNumber = math.random(0, 100)
    --    randomX = math.random(speedDoublePowerUp.img:getWidth() ,love.graphics.getWidth()-speedDoublePowerUp.img:getWidth())
    --
    --    if  randomNumber < 100 * speedDoublePowerUp.spawnChance then
    --        speedDoublePowerUp.x = randomX
    --        speedDoublePowerUp.y = -speedDoublePowerUp.img:getHeight()
    --        table.insert(powerUps, speedDoublePowerUp)
    --    end
    --
    --    for i, powerUp in ipairs(powerUps) do
    --        powerUp.y = powerUp.y + (powerUp.speed * dt)
    --        if powerUp.y > 850 then
    --            table.remove(powerUps, i)
    --        end
    --    end

    -- Check Collision with powerUp and Player and assign stat boost
    for i, powerUp in ipairs(powerUps) do
        if CheckCollision(powerUp.x, powerUp.y, powerUp.img:getWidth(), powerUp.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
            -- DO SOMETHING HERE ON COLLISION
            table.remove(powerUps, i)

            -- Sound Effect When Player Hit PowerUp
            local sound = sfxr.newSound()
            sound:randomPowerup(44)
            local sounddata = sound:generateSoundData()
            local source = love.audio.newSource(sounddata)
            source:play()
        end
    end

    -- Check Collision with powerUp and bullet and remove the bullet -- TODO: HARD DIFFICULTY
    for i, powerUp in ipairs(powerUps) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(powerUp.x, powerUp.y, powerUp.img:getWidth(), powerUp.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
            end
        end
    end

end

function powerUpClass:draw(dt)
    for i, powerUp in ipairs(powerUps) do
        love.graphics.draw(powerUp.img, powerUp.x , powerUp.y )
    end
end