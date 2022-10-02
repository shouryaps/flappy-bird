Score = Class {}

local digits = {
    [0] = love.graphics.newImage("resources/sprites/0.png"),
    [1] = love.graphics.newImage("resources/sprites/1.png"),
    [2] = love.graphics.newImage("resources/sprites/2.png"),
    [3] = love.graphics.newImage("resources/sprites/3.png"),
    [4] = love.graphics.newImage("resources/sprites/4.png"),
    [5] = love.graphics.newImage("resources/sprites/5.png"),
    [6] = love.graphics.newImage("resources/sprites/6.png"),
    [7] = love.graphics.newImage("resources/sprites/7.png"),
    [8] = love.graphics.newImage("resources/sprites/8.png"),
    [9] = love.graphics.newImage("resources/sprites/9.png")
}
local scoreY = 30

-- constructor
function Score:init()
    self.score = 0
    self.rDigits = {0}
    self.totalWidth = digits[0]:getWidth()
    self.x = (SCREEN_WIDTH / 2) - (self.totalWidth / 2)
end

-- score increament
function Score:point()
    self.score = self.score + 1
    self:_precalculate()
end

-- pre calculates the values before next render
-- this function assumes score value more than 0
-- this is better because updating score on points make sense here instead of fps
function Score:_precalculate()
    self.totalWidth = 0
    self.rDigits = {}
    -- case with score > 0
    local number = self.score
    while number > 0 do
        local digit = number % 10
        table.insert(self.rDigits, 0, digit)
        self.totalWidth = self.totalWidth + digits[digit]:getWidth()
        number = math.floor(number / 10)
    end
    self.x = (SCREEN_WIDTH / 2) - (self.totalWidth / 2)
end


function Score:render()
    -- in above code atleast one entry in rDigits is guaranteed
    local cX = self.x -- current x
    for _, value in pairs(self.rDigits) do
        love.graphics.draw(digits[value], cX, scoreY)
        cX = cX + digits[value]:getWidth()
    end
    
end