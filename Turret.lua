local love = require('love')
local player = require('player')

function Turret(x, y)

    local startingShotInterval = 0.1
    return {
        x = x,
        y = y,
        width = 50,
        height = 50,
        angle = 0,
        shotInterval = startingShotInterval,
        timeUntilNextShot = startingShotInterval,
        closestEnemyIndex = -1,
        findClosestEnemy = function(self)
            local closestDistance = math.huge
            local closestIndex = -1

            for i, enemy in ipairs(Enemies) do
                local dx = enemy.x - self.x
                local dy = enemy.y - self.y
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance < closestDistance then
                    closestDistance = distance
                    closestIndex = i
                end
            end

            self.closestEnemyIndex = closestIndex
            return closestIndex
        end,
        shoot = function(self)
            if self.closestEnemyIndex ~= -1 then
                local closestEnemy = Enemies[self.closestEnemyIndex]
                if closestEnemy ~= nil then
                    local newBullet = Bullet(self.x, self.y, closestEnemy.x,
                                             closestEnemy.y)
                    table.insert(Bullets, newBullet)
                end
            end
        end,

        handleShotTimer = function(self, dt)
            self.timeUntilNextShot = self.timeUntilNextShot - dt
            if self.timeUntilNextShot < 0 then
                self:shoot()
                self.timeUntilNextShot = self.shotInterval

            end
        end,

        rotate = function(self)
            if self.closestEnemyIndex ~= -1 then
                local closestEnemy = Enemies[self.closestEnemyIndex]
                local enemyX, enemyY = closestEnemy.x, closestEnemy.y
                local dx = enemyX - (self.x + self.width / 2)
                local dy = enemyY - (self.y + self.height / 2)
                self.angle = math.atan2(dy, dx) + math.pi / 2
            end
        end,

        draw = function(self)
            love.graphics.push()
            love.graphics.translate(self.x + self.width / 2,
                                    self.y + self.height / 2)
            love.graphics.rotate(self.angle)
            love.graphics.translate(-self.width / 2, -self.height / 2)
            love.graphics.polygon('fill', 0, 0, self.width, 0, self.width / 2,
                                  self.height)
            love.graphics.pop()
        end
    }

end

return Turret
