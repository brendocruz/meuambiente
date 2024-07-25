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
			['<C-z>'] = mappings.run_cur_file(),
			['tcc'] = mappings.close_current_terminal(),
		},
	},
	run = {
		python = {
			variables = {
				['PYTHONPATH'] = function() vim.fn.getcwd() end
			},
			command = function()
				local command = 'python3 ' .. vim.api.nvim_buf_get_name(0)
				command = command .. ' <ARGS>'
				return command
			end
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
