local love = require('love')

function Enemy(level)
    local x, y
    -- Generate random starting position outside the game board
    if math.random() < 0.5 then
        x = -30 -- Start outside the left side
        y = math.random(0, Game.height) -- Random y position within the height
    else
        x = math.random(0, Game.width) -- Random x position within the width
        y = Game.height + 30 -- Start outside the bottom side
    end

    return {
        level = level,
        x = x,
        y = y,
        width = 50 - level * 2,
        height = 50 - level * 2,
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

            -- Detect collision with player
            local playerWidthHalf = player.width / 2
            local playerHeightHalf = player.height / 2

            if self.x + self.width / 2 > player.x - playerWidthHalf and self.x -
                self.width / 2 < player.x + playerWidthHalf and self.y +
                self.height / 2 > player.y - playerHeightHalf and self.y -
                self.height / 2 < player.y + playerHeightHalf then
                Player.health = Player.health - 1
                self.health = 0
                table.remove(Enemies, i)
            end

        end,

        draw = function(self)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle('fill', self.x, self.y, self.width,
                                    self.height)
        end,

        takeDamage = function(self, damage)
            self.health = self.health - damage
            local isDead = self.health < 1

            return isDead
        end

    }
end

return Enemy
