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

---@param buf_id? integer
---@return BufferType
M.get_buf_type = function(buf_id)
	if buf_id == nil then
		buf_id = 0
	end

	local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf_id })
	if buftype == '' then
		return 'normal'
	end
	return buftype
end

---@return boolean
M.is_cur_buf_unnamed = function()
	return (vim.fn.expand("%:p") == '')
end

---@param buf_id? integer
---@return string
M.get_buf_path = function(buf_id)
	if buf_id == nil then
		buf_id = 0
	end

	local path = ''
	local buf_type = M.get_buf_type(buf_id)
	if buf_type == 'normal' then
		path = vim.fn.expand('%:p:h')
	elseif buf_type == 'terminal' then
		local parts = vim.split(vim.fn.expand('%:p:h'), '//', { plain = true })
		path = parts[2]
	end

	return path
end

return M
