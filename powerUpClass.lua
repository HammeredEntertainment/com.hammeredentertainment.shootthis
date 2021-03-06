--
-- Created by IntelliJ IDEA.
-- User: BenjaminSchatter
-- Date: 24.08.16
-- Time: 18:17
-- To change this template use File | Settings | File Templates.
--
powerUpImg = nil
createPowerUpTimerMax = 10
createPowerUpTimer = createPowerUpTimerMax
increaseSpawnChanceTimer = 1
powerUpClass = {}
powerUpActive = false
powerUpBlockTimerDefault = 5.0
powerUpBlockTimer = 0
defaultSpawnChance = 0.1

speedDoublePowerUp = {x = nil, y = nil, speedMultiplier = 2.0, speed = 200, spawnChance = defaultSpawnChance, img = love.graphics.newImage("assets/speedDoublePowerUp.png")}

function powerUpClass:load()
    powerUpImg = speedDoublePowerUp.img
end

function powerUpClass:update(dt)
    -- Create a PowerUp
    createPowerUpTimer = createPowerUpTimer - (1*dt)
    if createPowerUpTimer < 0 then
        createPowerUpTimer = createPowerUpTimerMax

        randomNumber = math.random(powerUpImg:getWidth(), love.graphics.getWidth() - powerUpImg:getWidth())

        newPowerUp = { x = randomNumber, y = -powerUpImg:getHeight(), speed = 100, img = powerUpImg, speedMultiplier = 2.0, effectTime = 2.0}
        table.insert(powerUps, newPowerUp)
      else
        -- if there is no new power up, then you got a higher chance next time
         increaseSpawnChanceTimer = increaseSpawnChanceTimer- (1*dt)
        if  increaseSpawnChanceTimer < 0 then
         if math.random(0,100) > 95 then
           createPowerUpTimer = createPowerUpTimer - 1
           increaseSpawnChanceTimer = 1
        end
      end
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
    if powerUpBlockTimer > 0 then
        powerUpBlockTimer = powerUpBlockTimer - (1*dt)
        end


        -- Check Collision with powerUp and Player and assign stat boost
    for i, powerUp in ipairs(powerUps) do
        if powerUpBlockTimer <= powerUpBlockTimerDefault - powerUp.effectTime and powerUpActive == true then
            player.speed = player.speed / powerUp.speedMultiplier
            powerUpActive = false
        end


        if CheckCollision(powerUp.x, powerUp.y, powerUp.img:getWidth(), powerUp.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
            -- DO SOMETHING HERE ON COLLISION
            if powerUpBlockTimer <= 0 then
                powerUpActive = true
                player.speed = player.speed * powerUp.speedMultiplier;
                powerUpBlockTimer = powerUpBlockTimerDefault
            end
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
