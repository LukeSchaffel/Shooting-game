local love = require('love')

Player = {speed = 500, width = 30, height = 30}
Game = {width = 1200, height = 800}
Mouse = {}
Bullets = {}
Enemies = {}
local Enemy = require('Enemy')
local handleEnemySpawns = require('spawnEnemy')
local Bullet = require('Bullet')

function Player:move(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

    self.x = math.max(0, math.min(self.x, Game.width - self.width))
    self.y = math.max(0, math.min(self.y, Game.height - self.height))
end

local function moveBullets(dt)
    for i = #Bullets, 1, -1 do
        local bullet = Bullets[i]
        bullet:move(dt, i)
    end
end

function Player:shoot(dt)
    if Player.ammo > 0 then
        local newBullet = Bullet()
        table.insert(Bullets, newBullet)
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
    love.graphics.circle('fill', Player.x, Player.y, Player.width)

    love.graphics.setColor(1, 1, 1) -- White color for the circle
    love.graphics.circle('fill', Mouse.x, Mouse.y, 10) -- Draw a small circle at the mouse position

    love.graphics.setColor(1, 0, 0) -- Red color for bullets
    for _, bullet in ipairs(Bullets) do bullet:draw() end

    for _, enemy in ipairs(Enemies) do enemy:draw() end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then Player:shoot() end
end
