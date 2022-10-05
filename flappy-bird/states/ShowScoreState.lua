ShowScoreState = Class{__includes = State}

local gameOver = love.graphics.newImage(GAME_OVER_PATH)

function ShowScoreState:enter(params)
    Sounds[SOUND_HIT]:play()
    self.score = params.score
    self.x = (SCREEN_WIDTH / 2) - (gameOver:getWidth() / 2)
    self.y = (SCREEN_HEIGHT / 2) - (gameOver:getHeight() / 2)
    self.backgroundIndex = params.backgroundIndex
end

function ShowScoreState:update(dt)
    -- check to restart the game
    if TapHappened then
        GStateMachine:change(GAME_STATE_TITLE)
    end
end

function ShowScoreState:render()
    -- show the background
    love.graphics.draw(Backgrounds[self.backgroundIndex], 0, 0)

    -- show the game over screen
    love.graphics.draw(gameOver, self.x, self.y)

    -- show the score
    self.score:render()
end