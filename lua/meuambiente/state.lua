---@class State
---@field termbuffers TerminalBuffer[]
---@field lastfileid integer | nil
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

	local newstate = setmetatable({
		termbuffers = {},
		lastfileid = 1,
		run_config = {}
	}, State)

	---WARNING
	vim.api.nvim_create_autocmd({ 'BufLeave' }, {
		callback = function()
			newstate:update_last_file()
		end,
	})

	singleton = newstate
	return singleton
end



---Get the terminal buffer with the given index.
---@param index integer
---@return TerminalBuffer
function State:get_instance(index)
	return self.termbuffers[index]
end



---Set the terminal buffer in the given index.
---@param index integer
---@param termbuffer TerminalBuffer
---@return TerminalBuffer
function State:set_instance(index, termbuffer)
	self.termbuffers[index] = termbuffer
	return self.termbuffers[index]
end



---Close the terminal buffer with the given id.
---@param termid integer
function State:close_instance(termid)
	for key, instance in pairs(self.termbuffers) do
		if instance.termid == termid then
			vim.api.nvim_buf_delete(instance.termid, { force = true })
			self.termbuffers[key] = nil
		end
	end
end



---Update the last file variable with the current buffer id.
---@return nil
function State:update_last_file()
	-- Get current buffer filename.
	self.lastfileid = vim.api.nvim_get_current_buf()
end



return State
