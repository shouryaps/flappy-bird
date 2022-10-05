TitleState = Class{__includes = State}

local introImage = love.graphics.newImage(TITLE_SCREEN_PATH)
local yOffset = 78 -- to move the image a bit up

function TitleState:enter(params)
    -- initialize the bird
    self.bird = Bird()
    self.x = (SCREEN_WIDTH / 2) - (introImage:getWidth() / 2)
    self.y = (SCREEN_HEIGHT / 2) - (introImage:getHeight() / 2) - yOffset
    self.backgroundIndex = math.random(2) -- select a random time of day
end

function TitleState:update(dt)
    -- update bird
    self.bird:update(dt)
    -- start the game if condition met
    if TapHappened then
        GStateMachine:change(GAME_STATE_PLAY, {
            bird = self.bird,
            backgroundIndex = self.backgroundIndex,
        })
    end
end

function TitleState:render()
    -- show the background
    love.graphics.draw(Backgrounds[self.backgroundIndex], 0, 0)

    -- show the flappy bird title
    love.graphics.draw(introImage, self.x, self.y)

    -- draw the bird
    self.bird:render()
end