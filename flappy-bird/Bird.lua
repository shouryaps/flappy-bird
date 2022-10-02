Bird = Class {}

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
    self.y = self.y + self.dy -- apply velocity to position
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
