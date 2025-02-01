local love = require('love')

local pauseScreen = {

    draw = function()
        love.graphics.print("Paused, press Tab to contiune",
                            Game.width / 2 - 150, Game.height / 2)

    end

}

return pauseScreen
