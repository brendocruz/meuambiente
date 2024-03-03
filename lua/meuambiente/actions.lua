local state = require('meuambiente.state').new()
local TerminalInstance = require('meuambiente.instance')
local utils = require('meuambiente.utils')
local M = {}


---@param index integer
---@param bind_term? boolean
---@return nil
M.go_to_terminal = function(index, bind_term)
	-- Check if an instance already exists in the specified index.
	local instance = state:get_instance(index)
	if instance == nil then
		-- -- Check if the current buffer is not an unamed buffer.
		-- if not utils.is_cur_unnamed() then
			instance = TerminalInstance.new(state, bind_term)
			state:set_instance(index, instance)
		-- end
	-- Check if the instance is not binded to a terminal
	elseif not instance:is_binded() then
		-- Check if the current buffer is not a terminal
		if utils.get_buftype() ~= 'terminal' then
			instance:bind(vim.api.nvim_get_current_buf())
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
	if utils.get_buftype() ~= 'terminal' then
		return
	end
	local buf_id = vim.api.nvim_get_current_buf()
	vim.api.nvim_exec_autocmds('TermClose', { buffer = buf_id })
end

---@param index integer
M.toggle_bind_terminal = function(index)
	local instance = state:get_instance(index)
	local buftype = utils.get_buftype(0)

	if buftype == 'terminal' then
		instance:unbind()
	else
		local buf_id = vim.api.nvim_get_current_buf()
		instance:bind(buf_id)
	end
end

return M
