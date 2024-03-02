local config = require('meuambiente.config')
local M = {}


M.setup = function(_)
	local opts = { remap = true, silent = true }
	for mode, mappings in pairs(config.mappings) do
		for lhs, rhs in pairs(mappings) do
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end
end

return M
