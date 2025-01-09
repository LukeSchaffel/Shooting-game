local love = require('love')


local backGround =  love.graphics.newImage("sprites/Background/starBackground.png")

local function drawBackground()
  for i = 0, love.graphics.getWidth() / backGround:getWidth() do
    for j = 0, love.graphics.getHeight() / backGround:getHeight() do
        love.graphics.draw(backGround, i * backGround:getWidth(), j * backGround:getHeight())
    end
  end
end

return drawBackground