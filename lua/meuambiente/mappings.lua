local actions = require('meuambiente.actions')
local M = {}

---@param index integer
---@return function
M.go_to_terminal = function(index)
	return function()
		actions.go_to_terminal(index)
	end
end

---@return function
M.close_current_terminal = function()
	return function()
		actions.close_current_terminal()
	end
end

return M
