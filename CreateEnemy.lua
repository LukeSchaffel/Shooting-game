local love = require('love')
local enemyImg = love.graphics.newImage('sprites/enemyShip.png')

Numbers = {}
function CreateEnemy(level)
    local x, y
    -- Generate random starting position outside the game board
    local side = math.random(1, 4) -- Randomly choose a side (1: left, 2: right, 3: top, 4: bottom)
    if side == 1 then
        x = -30
        y = math.random(0, Game.height)
    elseif side == 2 then
        x = Game.width + 30
        y = math.random(0, Game.height)
    elseif side == 3 then
        x = math.random(0, Game.width)
        y = -30
    else
        x = math.random(0, Game.width)
        y = Game.height + 30
    end

    return {
        level = level,
        x = x,
        y = y,
        width = 50,
        height = 50,
        health = 0 + level,
        speed = 100 * level,

        move = function(self, dt, player, i)
            if player.x - self.x > 0 then
                self.x = self.x + self.speed * dt
            elseif player.x - self.x < 0 then
                self.x = self.x - self.speed * dt
            end

            if player.y - self.y > 0 then
                self.y = self.y + self.speed * dt
            elseif player.y - self.y < 0 then
                self.y = self.y - self.speed * dt
            end

            local dx = player.x - self.x
            local dy = player.y - self.y
            self.angle = math.atan2(dy, dx)

            -- Detect collision with player
            if self.x < player.x + player.width and self.x + self.width >
                player.x and self.y < player.y + player.height and self.y +
                self.height > player.y then
                player.health = player.health - 1
                self.health = 0
                table.remove(Enemies, i)
            end

        end,

        draw = function(self)
            local spriteWidth = enemyImg:getWidth()
            local spriteHeight = enemyImg:getHeight()

            local scaleX = self.width / spriteWidth
            local scaleY = self.height / spriteHeight

            local originX = spriteWidth / 2
            local originY = spriteHeight / 2

            -- Hit box info
            -- love.graphics.setColor(0, 0, 0)
            -- love.graphics.rectangle( 'fill', self.x, self.y, self.width,
            --                         self.height)
            -- love.graphics.setColor(1, 1, 1)
            love.graphics.draw(enemyImg, self.x + self.width / 2,
                               self.y + self.height / 2,
                               self.angle + math.pi / 2, 1 / 2, 1 / 2, originX,
                               originY)
        end,

        takeDamage = function(self, damage)
            self.health = self.health - damage
            local isDead = self.health < 1

            return isDead
        end

    }
end

return CreateEnemy
