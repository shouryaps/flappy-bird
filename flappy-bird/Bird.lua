Bird = Class {}

local BIRD_PATH = "resources/sprites/yellowbird.png"
local BIRD_X = 88
local FLAP_SPEED = 5 -- will be applied negatively
local GRAVITY = 20

-- constructor
function Bird:init()
    self.image = love.graphics.newImage(BIRD_PATH)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
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
    self.dy = self.dy + (GRAVITY * dt) -- apply gravity to make bird go downwards
    self.y = self.y + self.dy -- apply velocity to position

    -- don't allow y to leave the base
    if self.y > self.maxY then
        self.y = self.maxY
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
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