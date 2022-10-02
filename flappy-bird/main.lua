local lick = require "utils/lick"
lick.reset = true -- reload love.load everytime you save

local push = require 'utils/push'
Class = require 'utils/class'

require('constants')
require('Bird')
require('Pipe')

local background
local base = love.graphics.newImage(BASE_PATH)
local baseScroll = 0
local backgroundScroll = 0

local bird
local pipes = {}
local spawnTimer = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialise the random generator
    math.randomseed(os.time())

    -- select a random time of day and load the image
    background = love.graphics.newImage(math.random(2) == 1 and DAY_BACKGROUND_PATH or NIGHT_BACKGROUND_PATH)

    -- set the title and setup screen
    love.window.setTitle('Flappy Bird')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize the bird
    bird = Bird()

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
    -- parallax scrolling
    baseScroll = (baseScroll + BASE_SCROLL_SPEED * dt) % BASE_LOOP_POINT
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT

    -- update pipes
    spawnTimer = spawnTimer + dt
    if spawnTimer > SPAWN_PIPE_SECONDS then
        -- add a new pipe
        table.insert(pipes, Pipe())
        -- reset the timer
        spawnTimer = 0
    end

    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        if pipe.x < -pipe.width then -- pipe crosses the screen on left
            table.remove(pipes, k)
        end
    end

    -- update bird
    bird:update(dt)

    -- set the table as blank
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw background with negative x offset
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw pipe before the base
    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    -- draw base in bottom of screen with negative x offset
    love.graphics.draw(base, -baseScroll, VIRTUAL_HEIGHT - BASE_HEIGHT)

    -- draw bird
    bird:render()

    push:finish()
end
