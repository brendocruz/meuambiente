local utils = require('meuambiente.utils')
local state = require('meuambiente.state')
local TerminalBuffer = require('meuambiente.terminal')
-- local config = require('meuambiente.config')


local M = {}


---@param index integer
---@param bindterm? boolean
---@return nil
M.goto_terminal = function(index, bindterm)
	local buftype = utils.get_buf_type()
	if buftype ~= 'normal' and buftype ~= 'terminal' then
		return
	end

	local termbuffer = state.termbuffers[index]

	if termbuffer == nil then
		termbuffer = TerminalBuffer.new(bindterm)
		state.termbuffers[index] = termbuffer
	end

	if termbuffer then
		termbuffer:focus()
	end
end



M.close_current_terminal = function()
	if utils.get_buf_type() ~= 'terminal' then
		return
	end
	local termid = vim.api.nvim_get_current_buf()
	vim.api.nvim_exec_autocmds('TermClose', { buffer = termid })
end



---@param index integer
M.toggle_bind_terminal = function(index)
	local termbuffer = state.termbuffers[index]
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
	print('Disabled.')
	--local filetype = vim.bo.filetype

	--if state.run_config[filetype] == nil then
	--	return
	--end

	-----@type string
	--local command

	--if type(state.run_config[filetype]) == 'function' then
	--	command = state.run_config[filetype]()
	--else
	--	command = state.run_config[filetype]
	--	command = string.format(command, vim.api.nvim_buf_get_name(0))
	--end

	--local path = vim.fn.getcwd()
	--local termpath = 'term://' .. path .. '//' .. command
	--vim.cmd.edit(termpath)
end



return M
