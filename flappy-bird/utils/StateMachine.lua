--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed
-- -- due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with an identifier (typically a constant) and an intialisation function.
-- -- on initialisation init function is called for the state
-- -- render, update, enter and exit methods are also expected
--
-- gameState = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame") -- this can be used to transition to specified state
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed too.
--
-- State identifiers should have similar name as game state for better readability
-- i.e. MainMenu creates a state using the MainMenu table. This keeps things
-- straight forward.
--
--
StateMachine = Class{}

function StateMachine:init(states)
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = State()
	self.stateName = nil
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.stateName = stateName
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end

function StateMachine:state()
	return self.stateName
end