function Enemy(level)
    return {
        level = level,
        x = 20,
        y = 20,
        width = 30 - level,
        height = 30 - level,
        health = 1 + level,

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
