local mappings = require('meuambiente.mappings')

local default_config = {
	mappings = {
		n = {
			['<A-1>'] = mappings.go_to_terminal(1),
			['<A-2>'] = mappings.go_to_terminal(2),
			['<A-3>'] = mappings.go_to_terminal(3),
			['tcc'] = mappings.close_current_terminal(),
		},
	}
}

return default_config
