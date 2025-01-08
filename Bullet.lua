local love = require('love')

function Bullet()
    return {
        x = Player.x + Player.width / 2,
        y = Player.y + Player.height / 2,
        speed = 800,
        angle = math.atan2(Mouse.y - (Player.y + Player.height / 2),
                           Mouse.x - (Player.x + Player.width / 2)),
        radius = 5,
        move = function(bullet, dt, i)
            bullet.x = bullet.x + bullet.speed * dt * math.cos(bullet.angle)
            bullet.y = bullet.y + bullet.speed * dt * math.sin(bullet.angle)

            -- remove bullet after leaving screen
            if bullet.x < 0 or bullet.x > Game.width or bullet.y < 0 or bullet.y >
                Game.height then table.remove(Bullets, i) end

            -- Detect bullet collision with Enemies
            for j, enemy in ipairs(Enemies) do
                local bulletRadius = bullet.radius
                local enemyWidthHalf = enemy.width / 2
                local enemyHeightHalf = enemy.height / 2

                if bullet.x + bulletRadius > enemy.x and bullet.x - bulletRadius <
                    enemy.x + enemy.width and bullet.y + bulletRadius > enemy.y and
                    bullet.y - bulletRadius < enemy.y + enemy.height then

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

        end,
        draw = function(self)
            love.graphics.circle('fill', self.x, self.y, self.radius)
        end

    }

end
return Bullet
