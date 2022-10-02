Bird = Class {}

-- constructor
function Bird:init()
    self.image = love.graphics.newImage(BIRD_PATH)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = BIRD_X -- somewhere slightly to left
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2) -- start at middle of screen in Y-axis
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
