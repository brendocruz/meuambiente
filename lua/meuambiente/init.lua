local config = require('meuambiente.config')
local state = require('meuambiente.state')
local utils = require('meuambiente.utils')
local M = {}



local function add_autocmds()
	-- Auto command to update last file when leave a buffer.
	vim.api.nvim_create_autocmd({ 'BufLeave' }, {
		callback = function()
			if utils.get_buf_type() ~= 'normal' then
				return
			end

			-- if vim.api.nvim_buf_get_name(0) == '' then
			-- 	return
			-- end

			state.lastfileid = vim.api.nvim_get_current_buf()
		end,
	})
end



---@param userconfig? Config
M.setup = function(userconfig)
	if userconfig ~= nil then
		config.update(userconfig)
	end

	local opts = { remap = true, silent = true }
	for mode, mappings in pairs(config.config.mappings) do
		for lhs, rhs in pairs(mappings) do
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end

	state.config = config.config

	add_autocmds()
end



return M
