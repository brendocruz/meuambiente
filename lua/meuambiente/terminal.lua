local utils = require('meuambiente.utils')



---@enum (key) FocusedBuffer
local focusedbuffer = {
	terminal = 1,
	file = 2,
}



---@class TerminalBuffer
---@field bufid integer | nil
---@field termid integer
---@field state State
---@field curfocus FocusedBuffer
local TerminalBuffer = {}
TerminalBuffer.__index = TerminalBuffer



---@param state State
---@param bindterm? boolean
function TerminalBuffer.new(state, bindterm)

	-- Check whether it has to save the current buffer id.
	---@type integer | nil
	local bufid = vim.api.nvim_get_current_buf()
	if bindterm == false then
		bufid = nil
	elseif utils.is_cur_buf_unnamed() == true then
		bufid = nil
	elseif utils.get_buf_type() == 'terminal' then
		bufid = nil
	end


	-- Set path to the terminal.
	local path
	if bindterm == false then
		-- Set terminal path to the current working directory
		path = vim.fn.getcwd()
	else
		-- Get current buffer path.
		path = utils.get_buf_path()
	end


	-- Create new terminal buffer.
	local termpath = "term://" .. path .. "//bash"
	vim.cmd.edit(termpath)
	local termid = vim.api.nvim_get_current_buf()


	local instance = setmetatable({
		bufid    = bufid,
		termid   = termid,
		state    = state,
		curfocus = 'file'
	}, TerminalBuffer)


	-- Set auto command for when the instance is closed.
	vim.api.nvim_create_autocmd({ 'TermClose' }, {
		buffer = instance.termid,
		callback = function()
			instance.state:close_instance(instance.termid)
		end,
	})


	return instance
end



function TerminalBuffer:focus()
	if self.curfocus == 'file' then
		self.curfocus = 'terminal'
		vim.api.nvim_set_current_buf(self.termid)
		return
	end

	if self.bufid then
		self.curfocus = 'file'
		vim.api.nvim_set_current_buf(self.bufid)
		return
	end

	if self.state.lastfileid then
		self.curfoCus = 'file'
		vim.api.nvim_set_current_buf(self.state.lastfileid)
	end
end



---Bind the terminal to a file buffer.
---@param bufid integer
function TerminalBuffer:bind(bufid)
	self.bufid = bufid
end



---Unbind the terminal from a file buffer.
function TerminalBuffer:unbind()
	self.bufid = nil
end



---Check if the terminal is binded to a file buffer.
---@return boolean
function TerminalBuffer:is_binded()
	return not (self.bufid == nil)
end



return TerminalBuffer
