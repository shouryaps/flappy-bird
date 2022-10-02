Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage("resources/sprites/pipe.png")
local PIPE_SCROLL = 60

-- constructor
function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH -- out of bound initially
    self.orientation = orientation
    self.y = y
    -- pre-calculate the height visible
    if orientation == BOTTOM then
        self.height = VIRTUAL_HEIGHT - self.y - BASE_HEIGHT
    else
        self.height = self.y
    end
end

function Pipe:update(dt)
    self.x = self.x - (PIPE_SCROLL * dt)
end

function Pipe:render()
    if self.orientation == BOTTOM then
        love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    else
        love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1, -1) -- scale y - axis
    end
end
