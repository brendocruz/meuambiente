local M = {}

---@enum (key) BufferType
local buffer_type = {
	normal   = 1,
	acwrite  = 2,
	help     = 3,
	nofile   = 4,
	nowrite  = 5,
	quickfix = 6,
	terminal = 7,
	prompt   = 8,
}

---@param bufid? integer
---@return BufferType
M.get_buf_type = function(bufid)
	if bufid == nil then
		bufid = 0
	end

	local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufid })
	if buftype == '' then
		return 'normal'
	end
	return buftype
end

---@return boolean
M.is_cur_buf_unnamed = function()
	return (vim.fn.expand("%:p") == '')
end

---@param bufid? integer
---@return string
M.get_buf_path = function(bufid)
	if bufid == nil then
		bufid = 0
	end

	local path = ''
	local buftype = M.get_buf_type(bufid)
	if buftype == 'normal' then
		path = vim.fn.expand('%:p:h')
	elseif buftype == 'terminal' then
		local parts = vim.split(vim.fn.expand('%:p:h'), '//', { plain = true })
		path = parts[2]
	end

	return path
end

return M
