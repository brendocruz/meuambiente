local config = require('meuambiente.config')
local state = require('meuambiente.state').new()
local M = {}


M.setup = function(_)
	local opts = { remap = true, silent = true }
	for mode, mappings in pairs(config.mappings) do
		for lhs, rhs in pairs(mappings) do
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end

	state.run_config = config.run
end

return M
