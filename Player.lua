local love = require('love')

local Player = {}
Player.speed = 500
Player.width = 50
Player.height = 50

-- Initialize player variables
function Player:init()
    self.x = 200
    self.y = 200
    self.health = 3
    self.ammo = 100
    self.kills = 0
    self.angle = 0
end

-- Player movement logic
function Player:move(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

    -- Constrain player position within the game window
    self.x = math.max(0, math.min(self.x, Game.width - self.width))
    self.y = math.max(0, math.min(self.y, Game.height - self.height))
end

-- Shooting logic
function Player:shoot()
    -- if self.ammo > 0 then
        local newBullet = Bullet()
        table.insert(Bullets, newBullet)
        self.ammo = self.ammo - 1
    -- end
end

-- Player rotation towards mouse position
function Player:rotate()
    local dx = Mouse.x - (self.x + self.width / 2)
    local dy = Mouse.y - (self.y + self.height / 2)
    self.angle = math.atan2(dy, dx) + math.pi / 2
end

-- Draw the player sprite with rotation
function Player:draw()
    local currentSprite = self.health < 2 and self.damagedSprite or self.sprite

    local spriteWidth = currentSprite:getWidth()
    local spriteHeight = currentSprite:getHeight()

    local scaleX = self.width / spriteWidth
    local scaleY = self.height / spriteHeight
    local originX = spriteWidth / 2
    local originY = spriteHeight / 2

    love.graphics.draw(currentSprite, self.x + self.width / 2,
                       self.y + self.height / 2, self.angle, scaleX, scaleY,
                       originX, originY)
end

return Player
