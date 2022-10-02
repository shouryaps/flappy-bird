ShowScoreState = Class{__includes = State}

local gameOver = love.graphics.newImage(GAME_OVER_PATH)

function ShowScoreState:enter(params)
    self.score = params.score
    self.x = (VIRTUAL_WIDTH / 2) - (gameOver:getWidth() / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (gameOver:getHeight() / 2)
end

function ShowScoreState:update(dt)
    -- check to restart the game
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        GStateMachine:change(GAME_STATE_TITLE)
    end
end

function ShowScoreState:render()
    -- show the game over screen
    love.graphics.draw(gameOver, self.x, self.y)

    -- show the score
    love.graphics.printf(tostring(self.score), 0, 10, VIRTUAL_WIDTH, 'center')
end