local push = require 'utils/push'
Class = require 'utils/class'

require('constants')
require('Bird')
require('PipePair')
require('Pipe')

-- state machine and states
require('utils/StateMachine')
require('states/State')
require('states/TitleState')
require('states/PlayState')
require('states/ShowScoreState')

local background
local base = love.graphics.newImage(BASE_PATH)
local baseScroll = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialise the random generator
    math.randomseed(os.time())

    -- select a random time of day and load the image
    -- background = love.graphics.newImage(math.random(2) == 1 and DAY_BACKGROUND_PATH or NIGHT_BACKGROUND_PATH)
    background = love.graphics.newImage(DAY_BACKGROUND_PATH) -- force day background for now

    -- set the title and setup screen
    love.window.setTitle('Flappy Bird')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- define the global game state machine
    GStateMachine = StateMachine {
        [GAME_STATE_TITLE] = function() return TitleState() end,
        [GAME_STATE_PLAY] = function() return PlayState() end,
        [GAME_STATE_SHOW_SCORE] = function() return ShowScoreState() end,
    }
    -- set the initial game state
    GStateMachine:change(GAME_STATE_TITLE)

    -- table for storing keys pressed
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true -- store in table
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if GStateMachine:state() ~= GAME_STATE_SHOW_SCORE then
        -- scroll the base
        baseScroll = (baseScroll + BASE_SCROLL_SPEED * dt) % BASE_LOOP_POINT
    end

    -- now, we just update the state machine, which defers to the right state
    GStateMachine:update(dt)

    -- set the table as blank
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw background
    love.graphics.draw(background, 0, 0)

    -- draw based on game state
    GStateMachine:render()

    -- draw base in bottom of screen with negative x offset
    love.graphics.draw(base, -baseScroll, VIRTUAL_HEIGHT - BASE_HEIGHT)

    push:finish()
end
