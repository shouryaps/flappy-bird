local push = require 'utils/push'

require('constants')

local background
local base = love.graphics.newImage(BASE_PATH)
local baseScroll = 0
local backgroundScroll = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialise the random generator
    math.randomseed(os.time())

    -- select a random time of day and load the image
    background = love.graphics.newImage(math.random(2) == 1 and DAY_BACKGROUND_PATH or NIGHT_BACKGROUND_PATH)

    love.window.setTitle('Flappy Bird')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    baseScroll = (baseScroll + BASE_SCROLL_SPEED * dt) % BASE_LOOP_POINT
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT
end

function love.draw()
    push:start()

    -- draw background with negative x offset
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw base in bottom of screen with negative x offset
    love.graphics.draw(base, -baseScroll, VIRTUAL_HEIGHT - BASE_HEIGHT)

    push:finish()
end
