function Enemy()
    return {
        level = 1,
        x = 20,
        y = 20,
        width = 30,
        height = 30,
        health = 1,

        move = function(self, player)
            if player.x - self.x > 0 then
                self.x = self.x + self.level
            elseif player.x - self.x < 0 then
                self.x = self.x - self.level
            end

            if player.y - self.y > 0 then
                self.y = self.y + self.level
            elseif player.y - self.y < 0 then
                self.y = self.y - self.level
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
