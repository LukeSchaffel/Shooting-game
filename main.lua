Player = {speed = 500, width = 100, height = 100}
Game = {width = 1200, height = 800}
Mouse = {}
Bullets = {}
Enemies = {}
local Enemy = require('Enemy')
local handleEnemySpawns = require('spawnEnemy')

function Player:move(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

    self.x = math.max(0, math.min(self.x, Game.width - self.width))
    self.y = math.max(0, math.min(self.y, Game.height - self.height))
end

function moveBullets(dt)
    for i = #Bullets, 1, -1 do
        local bullet = Bullets[i]
        bullet.x = bullet.x + bullet.speed * dt * math.cos(bullet.angle)
        bullet.y = bullet.y + bullet.speed * dt * math.sin(bullet.angle)

        -- remove bullet after leaving screen
        if bullet.x < 0 or bullet.x > Game.width or bullet.y < 0 or bullet.y >
            Game.height then table.remove(Bullets, i) end

        -- Detect bullet collision with Enemies
        for j, enemy in ipairs(Enemies) do
            if bullet.x > enemy.x - enemy.width / 2 and bullet.x < enemy.x +
                enemy.width / 2 and bullet.y > enemy.y - enemy.height / 2 and
                bullet.y < enemy.y + enemy.height / 2 then

                local isDead = enemy:takeDamage(1)
                if isDead then
                    table.remove(Enemies, j)
                    Player.kills = Player.kills + 1
                    if Player.kills % 5 == 0 then
                        Game.level = Game.level + 1
                    end
                end
                table.remove(Bullets, i)
                break
            end

        end
    end
end

function Player:shoot(dt)
    if Player.ammo > 0 then
        local bullet = {
            x = self.x + self.width / 2,
            y = self.y + self.height / 2,
            speed = 800,
            angle = math.atan2(Mouse.y - (self.y + self.height / 2),
                               Mouse.x - (self.x + self.width / 2))
        }
        table.insert(Bullets, bullet)
        Player.ammo = Player.ammo - 1
    end
end

function love.load()
    Player.x = 200
    Player.y = 200
    Player.health = 5
    Player.ammo = 100
    Player.kills = 0
    Game.level = 1
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(0.14, 0.36, 0.46)
    local newEnemy = Enemy(Game.level)
    table.insert(Enemies, newEnemy)
end

function love.update(dt)
    Player:move(dt)
    Mouse.x, Mouse.y = love.mouse.getPosition()
    moveBullets(dt)
    handleEnemySpawns(dt)
    for _, enemy in ipairs(Enemies) do enemy:move(Player) end
end

function love.draw()
    -- Print ammo count at the bottom left
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Ammo: " .. Player.ammo, 10, Game.height - 20)
    -- Print Kills count at the top left
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Kills: " .. Player.kills, 10, 10)

    love.graphics.setColor(40, 50, 60)
    love.graphics.rectangle('fill', Player.x, Player.y, Player.width,
                            Player.height)

    love.graphics.setColor(1, 1, 1) -- White color for the circle
    love.graphics.circle('fill', Mouse.x, Mouse.y, 10) -- Draw a small circle at the mouse position

    love.graphics.setColor(1, 0, 0) -- Red color for bullets
    for _, bullet in ipairs(Bullets) do
        love.graphics.circle('fill', bullet.x, bullet.y, 5) -- Draw bullets as small circles
    end

    for _, enemy in ipairs(Enemies) do enemy:draw() end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then Player:shoot() end
end
