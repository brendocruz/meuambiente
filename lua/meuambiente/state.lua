local utils = require "meuambiente.utils"

---@class State
---@field instances TerminalInstance[]
---@field last_file_id integer | nil
---@field run_config table
local State = {}
State.__index = State

---@type State | nil
local singleton = nil

---@return State
function State.new()
	if singleton ~= nil then
		return singleton
	end

	local new_state = setmetatable({
		instances = {},
		last_file_id = 1,
		run_config = {}
	}, State)

	vim.api.nvim_create_autocmd({ 'BufLeave' }, {
		callback = function()
			new_state:save_cur_file()
		end,
	})

	singleton = new_state
	return singleton
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

---@return nil
function State:run_cur_file()
	local filetype = vim.bo.filetype

	if self.run_config[filetype] == nil then
		return
	end

	---@type string
	local command

	if type(self.run_config[filetype]) == 'function' then
		command = self.run_config[filetype]()
	else
		command = self.run_config[filetype]
		command = string.format(command, vim.api.nvim_buf_get_name(0))
	end

	local path = vim.fn.getcwd()
	local term_path = 'term://' .. path .. '//' .. command
	vim.cmd.edit(term_path)
end

return State
