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
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2) -- start at middle of screen in Y-axis

    self.dy = 0 -- initial velocity
end

function Bird:flap()
    self.dy = -FLAP_SPEED -- add negative gravity
end

function Bird:update(dt)
    self.dy = self.dy + (GRAVITY * dt) -- apply gravity to make bird go down
    if love.keyboard.wasPressed('space') then
        self.flap(self)
    end
    self.y = self.y + self.dy -- apply velocity to position

    -- don't allow y to leave the base
    local maxY = VIRTUAL_HEIGHT - BASE_HEIGHT - self.height
    if self.y > maxY then
        self.y = maxY
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
    -- draw a box for testing collision
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

function Bird:collides(pipe) -- axis-aligned bounding boxes (AABB)

    local pipe_x = pipe.x
    local pipe_y = pipe.y

    -- for top transform the x, y for pipe
    if pipe.orientation == TOP then
        pipe_y = 0
    end

    -- left edge is farther to the right for either
    if self.x > pipe_x + PIPE_WIDTH or pipe_x > self.x + self.width then
        return false
    end
    -- bottom edge is higher than top edge of either
    if self.y > pipe_y + pipe.height or pipe_y > self.y + self.height then
        return false
    end
    return true
end
