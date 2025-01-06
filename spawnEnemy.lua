local Enemy = require('Enemy')

local function spawnEnemy(level)
    local newEnemy = Enemy(level)
    table.insert(Enemies, newEnemy)
end

function handleEnemySpawns(dt)

    -- Game level is max amount of enemies for now
    if #Enemies >= Game.level then return end

    if math.random() < dt * 0.5 then -- ~50% chance per second
        spawnEnemy(Game.level)
    end
end

return handleEnemySpawns
