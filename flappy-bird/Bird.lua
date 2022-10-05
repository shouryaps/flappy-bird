Bird = Class {}

local birdSprites = {
    {
        love.graphics.newImage("resources/sprites/yellowbird-upflap.png"),
        love.graphics.newImage("resources/sprites/yellowbird-midflap.png"),
        love.graphics.newImage("resources/sprites/yellowbird-downflap.png")
    },
    {
        love.graphics.newImage("resources/sprites/bluebird-upflap.png"),
        love.graphics.newImage("resources/sprites/bluebird-midflap.png"),
        love.graphics.newImage("resources/sprites/bluebird-downflap.png")
    },
    {
        love.graphics.newImage("resources/sprites/redbird-upflap.png"),
        love.graphics.newImage("resources/sprites/redbird-midflap.png"),
        love.graphics.newImage("resources/sprites/redbird-downflap.png")
    },
}

local BIRD_X = 88
local FLAP_SPEED = 5 -- will be applied negatively
local GRAVITY = 20

local FLAP_DURATION = 0.5
local flapTimer = 0

-- constructor̦
function Bird:init()
    self.birdIndex = math.random(3) -- indicates the bird colour
    self.spriteIndex = 2 -- starting frame for flapping animation
    self.currentTime = 0
    self.width = birdSprites[self.birdIndex][self.spriteIndex]:getWidth()
    self.height = birdSprites[self.birdIndex][self.spriteIndex]:getHeight()
    self.x = BIRD_X -- somewhere slightly to left
    self.y = SCREEN_HEIGHT / 2 - (self.height / 2) -- start at middle of screen in Y-axis
    self.dy = 0 -- initial velocity
    self.maxY = SCREEN_HEIGHT - BASE_HEIGHT - self.height
end

function Bird:flap()
    self.dy = -FLAP_SPEED -- add negative gravity
    Sounds[SOUND_FLAP]:play()
end

function Bird:update(dt)
    -- allow movements only if game state play
    if GStateMachine:state() == GAME_STATE_PLAY then
        self.dy = self.dy + (GRAVITY * dt) -- apply gravity to make bird go downwards
        self.y = self.y + self.dy -- apply velocity to position
        -- don't allow y to leave the base
        if self.y > self.maxY then
            self.y = self.maxY
        end
    end

    flapTimer = flapTimer + dt
    if flapTimer >= FLAP_DURATION then
        flapTimer = flapTimer - FLAP_DURATION
    end

    -- update the sprite index
    self.spriteIndex = math.floor(flapTimer / FLAP_DURATION * #birdSprites[self.birdIndex])+1
    self.width = birdSprites[self.birdIndex][self.spriteIndex]:getWidth()
    self.height = birdSprites[self.birdIndex][self.spriteIndex]:getHeight()
end

function Bird:render()
    love.graphics.draw(birdSprites[self.birdIndex][self.spriteIndex], self.x, self.y)
    -- self:_showBounds()
end

function Bird:collides(pipe) -- axis-aligned bounding boxes (AABB)

    local pipeX = pipe.x
    local pipeY = pipe.y

    -- for top transform the y for pipe, to left most point
    if pipe.orientation == TOP then
        pipeY = 0
    end

    -- left edge is farther to the right for either
    if self.x > pipeX + PIPE_WIDTH or pipeX > self.x + self.width then
        return false
    end
    -- bottom edge is higher than top edge of either
    if self.y > pipeY + pipe.height or pipeY > self.y + self.height then
        return false
    end
    return true
end

-- function for seeing the rect around bird for testing collisions
function Bird:_showBounds()
    -- show a green rectange around bird
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end
