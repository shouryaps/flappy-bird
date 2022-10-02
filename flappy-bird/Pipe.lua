Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage("resources/sprites/pipe-green.png")
local PIPE_SCROLL = 60

-- constructor
function Pipe:init()
    self.x = VIRTUAL_WIDTH -- out of bound initially
    self.width = PIPE_IMAGE:getWidth()
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - self.width)
end

function Pipe:update(dt)
    self.x = self.x - (PIPE_SCROLL * dt)
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
