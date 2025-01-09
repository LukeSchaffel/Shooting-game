local love = require('love')
local anim8 = require 'lib/anim8'

-- Required modules
local handleEnemySpawns = require('spawnEnemy')
local Bullet = require('Bullet')
local Player = require('Player')
local explosionImg = love.graphics.newImage('sprites/laserRedShot.png')
local lifeImg = love.graphics.newImage('sprites/life.png')
local crosshair = love.graphics.newImage('sprites/crosshair094.png')

Game = {width = 1200, height = 800}
Mouse = {}
DeadEnemies = {}
local function moveBullets(dt)
    for i = #Bullets, 1, -1 do
        local bullet = Bullets[i]
        bullet:move(dt, i)
    end
end

local function init()
    -- Initializing the game state
    Player:init()
    Game.level = 1
    Game.isGameOver = false
    Bullets = {}
    Enemies = {}
end

function love.load()
    -- Load player sprite and initialize game state
    Player.sprite = love.graphics.newImage('sprites/player.png')
    Player.damagedSprite = love.graphics.newImage('sprites/playerDamaged.png')
    Player.angle = 0
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(0.14, 0.36, 0.46)

    init()
end

local function checkGameOver()
    if Player.health == 0 then Game.isGameOver = true end
end

local function updateDeadEnemies(dt)
    for idx, ex in ipairs(DeadEnemies) do
        ex.time = ex.time - dt
        if ex.time < 0 then table.remove(DeadEnemies, idx) end
    end
end

function love.update(dt)
    -- Get mouse position
    Mouse.x, Mouse.y = love.mouse.getPosition()

    -- Update game objects
    Player:move(dt)
    Player:rotate()
    moveBullets(dt)
    handleEnemySpawns(dt)
    updateDeadEnemies(dt)
    -- Move enemies
    for _, enemy in ipairs(Enemies) do enemy:move(dt, Player) end

    -- Check game over condition
    checkGameOver()
end

function love.draw()
    -- Game over condition
    if Game.isGameOver then
        love.graphics.setColor(1, 1, 1) -- White color for the text
        love.graphics.setFont(love.graphics.newFont(30)) -- Set font size
        love.graphics.print("Game Over", Game.width / 2 - 100,
                            Game.height / 2 - 50) -- Display "Game Over" at the center of the screen
        love.graphics.print("You scored" .. Player.kills .. "points",
                            Game.width / 2 - 150, Game.height / 2 - 50) -- Display "Game Over" at the center of the screen
        love.graphics.print("Press 'R' to restart", Game.width / 2 - 2000,
                            Game.height / 2) -- Display restart instructions
        return
    end

    -- Print ammo count at the bottom left
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.print("Ammo: " .. Player.ammo, 10, Game.height - 20)

    -- Draw player lives
    for i = 1, Player.health do
        love.graphics.draw(lifeImg, i * (lifeImg:getWidth() + 20),
                           Game.height - 50)
    end

    -- Print Kills count at the top left
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Kills: " .. Player.kills, 10, 10)

    -- Draw mouse position as a circle
    -- love.graphics.setColor(1, 1, 1) -- White color for the circle
    -- love.graphics.circle('fill', Mouse.x, Mouse.y, 10) -- Draw a small circle at the mouse position
    love.graphics.draw(crosshair, Mouse.x, Mouse.y, 0, 1 / 3, 1 / 3,
                       crosshair:getWidth() / 2, crosshair:getHeight() / 2)

    for _, bullet in ipairs(Bullets) do bullet:draw() end
    -- Draw explosions
    for _, ex in ipairs(DeadEnemies) do
        love.graphics.draw(explosionImg, ex.x, ex.y, ex.time * 100)
    end
    -- Draw enemies
    for _, enemy in ipairs(Enemies) do enemy:draw() end
    -- Draw the player
    Player:draw()

end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then Player:shoot() end
end

function love.keypressed(key) if key == "r" then init() end end
