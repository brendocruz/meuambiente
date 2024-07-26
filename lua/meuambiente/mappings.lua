local actions = require('meuambiente.actions')
local M = {}



---@param index integer
---@param bindterm? boolean
---@return function
M.goto_terminal = function(index, bindterm)
	return function()
		actions.goto_terminal(index, bindterm)
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



---@param index integer
---@param showeditwin boolean
M.goto_tablayout = function(index, showeditwin)
	return function()
		actions.goto_tablayout(index, showeditwin)
	end
end



M.run_tablayout = function()
	return function()
		actions.run_tablayout()
	end
end


return M
