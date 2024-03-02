---@enum InstanceFocus
local INSTANCEFOCUS = {
	terminal = 1,
	file = 2,
}

---@class TerminalInstance
---@field buf_id integer
---@field term_id integer
---@field state State
---@field cur_focus InstanceFocus
local TerminalInstance = {}
TerminalInstance.__index = TerminalInstance



---@param state State
function TerminalInstance.new(state)
	-- Get current buffer id.
	local buf_id = vim.api.nvim_get_current_buf()

	-- Get current buffer directory.
	local path = vim.fn.expand('%:p:h')

	-- Create terminal path.
	local term_path = "term://" .. path .. "//bash"

	-- Create new terminal instance.
	vim.cmd.edit(term_path)

	-- Get terminal id.
	local term_id = vim.api.nvim_get_current_buf()

	local instance = setmetatable({
		buf_id = buf_id,
		term_id = term_id,
		state = state,
		cur_focus = INSTANCEFOCUS.file
	}, TerminalInstance)

	-- Set autocmd called when the instance is closed.
	vim.api.nvim_create_autocmd({ 'TermClose' }, {
		buffer = instance.term_id,
		callback = function()
			instance.state:close_instance(instance.term_id)
		end,
	})

	return instance
end

function TerminalInstance:focus()
	if self.cur_focus == INSTANCEFOCUS.file then
		self.cur_focus = INSTANCEFOCUS.terminal
		vim.api.nvim_set_current_buf(self.term_id)
	else
		self.cur_focus = INSTANCEFOCUS.file
		vim.api.nvim_set_current_buf(self.buf_id)
	end
end

return TerminalInstance
