local love = require('love')
local player = require('player')
local anim8 = require('lib/anim8')
local turretImage = love.graphics.newImage('sprites/turret_FACE.png')
local spriteWidth = turretImage:getWidth()
local spriteHeight = turretImage:getHeight()
local frameWidth = 32
local frameHeight = 32
local g = anim8.newGrid(frameWidth, frameHeight, spriteWidth, spriteHeight)
function Turret(x, y)

    local startingShotInterval = 0.1
    local shootingAnimationDuration = 0.5 -- Duration of the shooting animation

    return {
        x = x,
        y = y,
        width = 50,
        height = 50,
        angle = 0,
        shotInterval = startingShotInterval,
        timeUntilNextShot = startingShotInterval,
        closestEnemyIndex = -1,
        animation = anim8.newAnimation(g(1, '1-4'), 0.1),
        isShooting = false,
        shootTimer = 0,
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
                                             closestEnemy.y, 3000, 0.1)
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
                self.angle = math.atan2(dy, dx)
            end
        end,

        draw = function(self)
            local scaleX = self.width / frameWidth
            local scaleY = self.height / frameHeight
            local originX = frameWidth / 2
            local originY = frameHeight / 2
            self.animation:draw(turretImage, self.x + self.width / 2,
                                self.y + self.height / 2, self.angle, scaleX,
                                scaleY, originX, originY)
        end
    }

end

return Turret
