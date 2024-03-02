local state = require('meuambiente.state').new()
local TerminalInstance = require('meuambiente.instance')
local M = {}


---@param index integer
---@return nil
M.go_to_terminal = function(index)
	local instance = state:get_instance(index)
	if instance == nil then
		if not (vim.fn.expand("%:p") == '') then
			instance = TerminalInstance.new(state)
			state:set_instance(index, instance)
		end
	end

	if instance then
		instance:focus()
	end
end

M.close_terminal = function(index)
	state:close_instance(state.instances[index].term_id)
end

M.close_current_terminal = function()
	local buffer_id = vim.api.nvim_get_current_buf()
	local buftype = vim.api.nvim_get_option_value('buftype', {
		buf = buffer_id
	})

	if buftype ~= 'terminal' then
		return
	end

	vim.api.nvim_exec_autocmds('TermClose', { buffer = buffer_id })
end

return M
