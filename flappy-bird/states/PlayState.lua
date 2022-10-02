PlayState = Class{__includes = State}

function PlayState:enter(params)
    self.bird = params.bird
    self.pipePairs = {} -- table storing pipe pairs
    self.spawnTimer = 0 -- timer for spawing pipe pairs
    self.score = 0 -- keep track of score
end

function PlayState:update(dt)
    -- update pipes
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > SPAWN_PIPE_SECONDS then
        -- add a new pipe pair
        table.insert(self.pipePairs, PipePair())
        -- reset the timer
        self.spawnTimer = 0
    end

    for _, pair in pairs(self.pipePairs) do
        pair:update(dt) -- update pipe pair

        -- check for collisions
        for _, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- show score
                GStateMachine:change(GAME_STATE_SHOW_SCORE, {
                    score = self.score
                })
            end
        end
    end

    -- flap the bird
    if love.keyboard.wasPressed('space') then
        self.bird:flap()
    end

    -- update bird
    self.bird:update(dt)

    -- see if bird has hit ground
    if self.bird.y + self.bird.height >= VIRTUAL_HEIGHT - BASE_HEIGHT then
        -- show score
        GStateMachine:change(GAME_STATE_SHOW_SCORE, {
            score = self.score
        })
    end

    -- remove flagged pairs, save memory!
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
end

function PlayState:render()
    -- draw the bird
    self.bird:render()
    -- draw pipe pairs before the base
    for _, pair in pairs(self.pipePairs) do
        pair:render()
    end
    -- show the score
    love.graphics.printf(tostring(self.score), 0, 10, VIRTUAL_WIDTH, 'center')
end