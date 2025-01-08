local love = require('love')
local anim8 = require 'lib/anim8'

-- Required modules
local handleEnemySpawns = require('spawnEnemy')
local Bullet = require('Bullet')
local Player = require('Player')

Game = {width = 1200, height = 800}
Mouse = {}

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
    Player.angle = 0
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(0.14, 0.36, 0.46)

    init()
end

local function checkGameOver()
    if Player.health == 0 then Game.isGameOver = true end
end

function love.update(dt)
    -- Get mouse position
    Mouse.x, Mouse.y = love.mouse.getPosition()

    -- Update game objects
    Player:move(dt)
    Player:rotate()
    moveBullets(dt)
    handleEnemySpawns(dt)

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
        love.graphics.print("Press 'R' to restart", Game.width / 2 - 150,
                            Game.height / 2) -- Display restart instructions
        return
    end

    -- Print ammo count at the bottom left
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Ammo: " .. Player.ammo, 10, Game.height - 20)

    -- Print Kills count at the top left
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Kills: " .. Player.kills, 10, 10)

    -- Draw the player
    Player:draw()

    -- Draw mouse position as a circle
    love.graphics.setColor(1, 1, 1) -- White color for the circle
    love.graphics.circle('fill', Mouse.x, Mouse.y, 10) -- Draw a small circle at the mouse position

    -- Draw bullets
    love.graphics.setColor(1, 0, 0) -- Red color for bullets
    for _, bullet in ipairs(Bullets) do bullet:draw() end

    -- Draw enemies
    for _, enemy in ipairs(Enemies) do enemy:draw() end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then Player:shoot() end
end

function love.keypressed(key) if key == "r" then init() end end
