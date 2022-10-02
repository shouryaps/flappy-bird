local push = require 'utils/push'
Class = require 'utils/class'

require('constants')
require('Bird')
require('PipePair')
require('Pipe')

local background
local base = love.graphics.newImage(BASE_PATH)
local baseScroll = 0
local backgroundScroll = 0

local bird
local pipePairs = {} -- table storing pipe pairs
local spawnTimer = 0 -- timer for spawing pipe pairs


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
        -- add a new pipe pair
        table.insert(pipePairs, PipePair())
        -- reset the timer
        spawnTimer = 0
    end

    for _, pair in pairs(pipePairs) do
        pair:update(dt) -- update pipe pair

        -- check for collisions
        for _, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
                print("Collision", bird.x, bird.y, pipe.x, pipe.y)
            end
        end
    end

    -- update bird
    bird:update(dt)

    -- remove flagged pairs
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    -- set the table as blank
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw background with negative x offset
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw bird
    bird:render()

    -- draw pipe pairs before the base
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- draw base in bottom of screen with negative x offset
    love.graphics.draw(base, -baseScroll, VIRTUAL_HEIGHT - BASE_HEIGHT)

    push:finish()
end
