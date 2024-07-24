local mappings = require('meuambiente.mappings')

local default_config = {
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
		nt = {

		}
	},
	run = {
		python = function()
			local command = 'PYTHONPATH=' .. vim.fn.getcwd()
			command = command .. ' python3 ' .. vim.api.nvim_buf_get_name(0)
			return command
		end
	}
}


Test = {
	python = {
		variables = {
			['PYTHONPATH'] = function() vim.fn.getcwd() end
		},
		command = 'python3'
	}
}

return default_config
