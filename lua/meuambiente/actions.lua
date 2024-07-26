local utils = require('meuambiente.utils')
local state = require('meuambiente.state')
local TerminalBuffer = require('meuambiente.terminal')
local TabLayout = require('meuambiente.tablayout')


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



---Go to the tab layout with the given index.
---@param index integer
---@param showeditwin boolean
M.goto_tablayout = function(index, showeditwin)
	if state.tablayouts[index] == nil then
		local filetype = vim.bo.filetype
		if state.config.run[filetype] == nil then
			return
		end
		state.tablayouts[index] = TabLayout.new(showeditwin)
		return
	end

	state.tablayouts[index]:focus()
end



M.run_tablayout = function()
	local tabpageid = vim.api.nvim_get_current_tabpage()

	---@type TabLayout
	local tablayout
	for _, valtab in pairs(state.tablayouts) do
		if valtab.tabpageid == tabpageid then
			tablayout = valtab
		end
	end

	if tablayout == nil then
		return
	end

	tablayout:run()
end


M.close_current_tablayout = function()
	local tabpageid = vim.api.nvim_get_current_tabpage()

	---@type TabLayout
	local tablayout
	for key, valtab in pairs(state.tablayouts) do
		if valtab.tabpageid == tabpageid then
			tablayout = valtab
			state.tablayouts[key] = nil
		end
	end

	if tablayout == nil then
		return
	end

	tablayout:close()
end



return M
