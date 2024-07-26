local mappings = require('meuambiente.mappings')

---@class CommandDescriptor
---@field variables { string: string | fun(): string }[]
---@field command string | fun(): string

---@class Config
---@field mappings? { n: { [string]: fun() }}
---@field run? { [string]: CommandDescriptor}

local M = {}

---@type Config
M.config = {
	mappings = {
		n = {
			['<A-1>'] = mappings.goto_terminal(1, false),
			['<A-2>'] = mappings.goto_terminal(2, false),
			['<A-3>'] = mappings.goto_terminal(3, false),
			['<A-S-1>'] = mappings.goto_terminal(1, true),
			['<A-S-2>'] = mappings.goto_terminal(2, true),
			['<A-S-3>'] = mappings.goto_terminal(3, true),
			['<C-1>'] = mappings.toggle_bind_terminal(1),
			['<C-2>'] = mappings.toggle_bind_terminal(2),
			['<C-3>'] = mappings.toggle_bind_terminal(3),
			['tcc'] = mappings.close_current_terminal(),

			['<leader>zz'] = mappings.goto_tablayout(1, false),
			['<leader>z2'] = mappings.goto_tablayout(2, true),
			['<leader>xx'] = mappings.run_tablayout(),
			['<leader>qq'] = mappings.close_current_tablayout(),
		},
	},
	run = {
		python = {
			variables = {
				['PYTHONPATH'] = function() return vim.fn.getcwd() end
			},
			command = 'python3 <FILE> <ARGS>',
		}
	}
}


---Update the configuration.
---@param userconfig Config
---@return nil
M.update = function(userconfig)
	for key, value in pairs(userconfig) do
		M[key] = value
	end
end

return M
