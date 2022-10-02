PipePair = Class {}

-- size of gap between pipes
local GAP_HEIGHT = 90

-- constructor
function PipePair:init()
    local y = math.random(200, 300)
    local smallBottom = math.random(2) == 1
    local yTop = y
    local yBottom = y
    if smallBottom then
        yBottom = yBottom + GAP_HEIGHT
    else
        yTop = yTop - GAP_HEIGHT
    end

    -- add padding to maintain gap, but randomise which orientation pipe is longer
    self.pipes = {
        [BOTTOM] = Pipe(BOTTOM, yBottom),
        [TOP] = Pipe(TOP, yTop)
    }
    -- flag to mark the pair to be removed
    self.remove = false
end

function PipePair:update(dt)
    -- pipe crossed screen on left side (check with either of top / bottom)
    if self.pipes[TOP].x <= -PIPE_WIDTH then
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
