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
        width = 30 - level,
        height = 30 - level,
        health = 0 + level,

        move = function(self, player)
            if player.x - self.x > 0 then
                self.x = self.x + 1
            elseif player.x - self.x < 0 then
                self.x = self.x - 1
            end

            if player.y - self.y > 0 then
                self.y = self.y + 1
            elseif player.y - self.y < 0 then
                self.y = self.y - 1
            end

        end,

        draw = function(self)
            love.graphics.setColor(0, 0, 0)
            love.graphics
                .circle('fill', self.x, self.y, self.width, self.height)
        end,

        takeDamage = function(self, damage)
            self.health = self.health - damage
            local isDead = self.health < 1

            return isDead
        end

    }
end

return Enemy
