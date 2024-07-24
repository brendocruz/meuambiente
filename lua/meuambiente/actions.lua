local utils = require('meuambiente.utils')
local state = require('meuambiente.state').new()
local TerminalBuffer = require('meuambiente.terminal')


local M = {}


---@param index integer
---@param bindterm? boolean
---@return nil
M.goto_terminal = function(index, bindterm)
	local termbuffer = state:get_instance(index)

	if termbuffer == nil then
		termbuffer = TerminalBuffer.new(state, bindterm)
		state:set_instance(index, termbuffer)
	end

	if termbuffer then
		termbuffer:focus()
	end
end



M.close_terminal = function(index)
	state:close_instance(state.termbuffers[index].termid)
end



M.close_current_terminal = function()
	if utils.get_buf_type() ~= 'terminal' then
		return
	end
	local bufid = vim.api.nvim_get_current_buf()
	vim.api.nvim_exec_autocmds('TermClose', { buffer = bufid })
end



---@param index integer
M.toggle_bind_terminal = function(index)
	local termbuffer = state:get_instance(index)
	local buftype = utils.get_buf_type(0)

	if buftype == 'terminal' then
		termbuffer:unbind()
	else
		local bufid = vim.api.nvim_get_current_buf()
		termbuffer:bind(bufid)
	end
end



---@return nil
M.run_cur_file = function()
	local filetype = vim.bo.filetype

	if state.run_config[filetype] == nil then
		return
	end

	---@type string
	local command

	if type(state.run_config[filetype]) == 'function' then
		command = state.run_config[filetype]()
	else
		command = state.run_config[filetype]
		command = string.format(command, vim.api.nvim_buf_get_name(0))
	end

	local path = vim.fn.getcwd()
	local termpath = 'term://' .. path .. '//' .. command
	vim.cmd.edit(termpath)
end



return M
