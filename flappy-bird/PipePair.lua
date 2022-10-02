PipePair = Class {}

-- size of gap between pipes
local GAP_HEIGHT = 90

-- constructor
function PipePair:init()
    self.x = VIRTUAL_WIDTH
    local y = math.random(200, 250)
    self.pipes = {
        [PIPE_TOP] = Pipe(PIPE_TOP, y),
        [PIPE_BOTTOM] = Pipe(PIPE_BOTTOM, y)
    }
    -- flag to mark the pair to be removed
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then -- pipe not crossed the screen on left side
        self.x = self.x - (PIPE_SCROLL * dt)
        self.pipes[PIPE_TOP].x = self.x
        self.pipes[PIPE_BOTTOM].x = self.x
    else
        self.remove = true -- flag for deletion
    end

    for _, pipe in pairs(self.pipes) do
        pipe:update(dt)
    end
end

function PipePair:render()
    for _, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
