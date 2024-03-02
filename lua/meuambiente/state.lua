---@class State
---@field instances TerminalInstance[]
local State = {}
State.__index = State

function State.new()
	return setmetatable({
		instances = {}
	}, State)
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
	for key, instance in ipairs(self.instances) do
		if instance.term_id == term_id then
			vim.api.nvim_buf_delete(instance.term_id, { force = true })
			self.instances[key] = nil
		end
	end
end

return State
