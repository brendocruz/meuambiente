local M = {}

---@param buf_id? integer
M.get_buftype = function(buf_id)
	if buf_id == nil then
		buf_id = 0
	end

	local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf_id })
	return buftype
end

M.is_cur_unnamed = function()
	return (vim.fn.expand("%:p") == '')
end

return M
