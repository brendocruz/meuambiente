local utils = require "meuambiente.utils"

---@class State
---@field instances TerminalInstance[]
---@field last_file_id integer | nil
local State = {}
State.__index = State

function State.new()


	local new_state = setmetatable({
		instances = {},
		last_file_id = 1
	}, State)

	vim.api.nvim_create_autocmd({ 'BufLeave' }, {
		callback = function()
			new_state:save_cur_file()
		end,
	})

	return new_state
end

---@param index integer
---@return TerminalInstance
function State:get_instance(index)
	return self.instances[index]
end

---@param index integer
---@param instance TerminalInstance
---@return TerminalInstance
function State:set_instance(index, instance)
	self.instances[index] = instance
	return self.instances[index]
end

---@param term_id integer
function State:close_instance(term_id)
	for key, instance in pairs(self.instances) do
		if instance.term_id == term_id then
			vim.api.nvim_buf_delete(instance.term_id, { force = true })
			self.instances[key] = nil
		end
	end
end

function State:create_instance()
	-- Get current buffer id.
	-- local buf_id = vim.api.nvim_get_current_buf()

	-- Get current buffer path.
	local path = utils.get_buf_path()

	-- Create terminal path.
	local term_path = "term://" .. path .. "//bash"

	-- Create new terminal instance.
	vim.cmd.edit(term_path)

	-- Get terminal id.
	-- local term_id = vim.api.nvim_get_current_buf()
end

function State:save_cur_file()
	-- Get current buffer filename.
	self.last_file_id = vim.api.nvim_get_current_buf()
end

return State
