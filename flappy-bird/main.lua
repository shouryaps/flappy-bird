local push = require 'utils/push'
Class = require 'utils/class'

require('constants')
require('Bird')
require('PipePair')
require('Pipe')
require('Score')

-- state machine and states
require('utils/StateMachine')
require('states/State')
require('states/TitleState')
require('states/PlayState')
require('states/ShowScoreState')

Backgrounds = {
    love.graphics.newImage(DAY_BACKGROUND_PATH),
    love.graphics.newImage(NIGHT_BACKGROUND_PATH),
}

local backgroundIndex = 1
local base = love.graphics.newImage(BASE_PATH)
local baseScroll = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialise the random generator
    math.randomseed(os.time())

    -- set the title and setup screen
    love.window.setTitle('Flappy Bird')
    push:setupScreen(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- load sound effects for global usage
    Sounds = {
        [SOUND_FLAP] = love.audio.newSource(SOUND_FLAP_PATH, 'static'),
        [SOUND_POINT] = love.audio.newSource(SOUND_POINT_PATH, 'static'),
        [SOUND_HIT] = love.audio.newSource(SOUND_HIT_PATH, 'static')
    }

    -- define the global game state machine
    GStateMachine = StateMachine {
        [GAME_STATE_TITLE] = function() return TitleState() end,
        [GAME_STATE_PLAY] = function() return PlayState() end,
        [GAME_STATE_SHOW_SCORE] = function() return ShowScoreState() end,
    }
    -- set the initial game state
    GStateMachine:change(GAME_STATE_TITLE)

    -- flag to store whether a tap happened
    TapHappened = false
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        TapHappened = true
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    TapHappened = true
end

function love.mousereleased( x, y, button, istouch, presses)
    TapHappened = true
end

function love.update(dt)
    if GStateMachine:state() ~= GAME_STATE_SHOW_SCORE then
        -- scroll the base
        baseScroll = (baseScroll + BASE_SCROLL_SPEED * dt) % BASE_LOOP_POINT
    end

    -- now, we just update the state machine, which defers to the right state
    GStateMachine:update(dt)

    -- reset the tap happened flag
    TapHappened = false
end

function love.draw()
    push:start()

    -- draw based on game state
    GStateMachine:render()

    -- draw base in bottom of screen with negative x offset
    love.graphics.draw(base, -baseScroll, SCREEN_HEIGHT - BASE_HEIGHT)

    push:finish()
end
