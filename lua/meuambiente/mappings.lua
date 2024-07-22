local actions = require('meuambiente.actions')
local M = {}

---@param index integer
---@param bind_term? boolean
---@return function
M.go_to_terminal = function(index, bind_term)
	return function()
		actions.go_to_terminal(index, bind_term)
	end
end

---@return function
M.close_current_terminal = function()
	return function()
		actions.close_current_terminal()
	end
end

---@param index integer
M.toggle_bind_terminal = function(index)
	return function()
		actions.toggle_bind_terminal(index)
	end
end

M.run_cur_file = function()
	return function()
		actions.run_cur_file()
	end
end

return M
