local state = require('meuambiente.state')


---@class Runconfig
---@field variables string
---@field command string



---@class TabLayout
---@field tabpageid integer
---@field termwinid integer
---@field termbufid integer
---@field argswinid integer
---@field argsbufid integer
---@field runconfig Runconfig
---@field prevtabid integer
---@field meinfocus boolean
---@field workdir string
local TabLayout = {}
TabLayout.__index = TabLayout



---Creates a new TabLayout instance.
---@param showeditwin boolean
---@return TabLayout
function TabLayout.new(showeditwin)
	local prevtabid = vim.api.nvim_get_current_tabpage()


	local filetype = vim.bo.filetype

	local command
	local desccmd = state.config.run[filetype]
	if type(desccmd.command) == 'function' then
		command = desccmd.command()
	else
		command = desccmd.command
	end


	local variables = ''
	for varname, value in pairs(desccmd.variables) do
		local resvalue
		if type(value) == 'function' then
			resvalue = value()
		else
			resvalue = value
		end

		---@cast resvalue string
		variables = variables .. varname .. '=' .. resvalue .. ' '
	end

	---@cast command string
	local filename = vim.api.nvim_buf_get_name(0)
	command, _ = string.gsub(command, '<FILE>', filename)

	local termcmd, _ = string.gsub(command, '<ARGS>', '')
	termcmd = vim.trim(variables) .. ' ' .. vim.trim(termcmd)

	local workdir = vim.fn.getcwd()
	local termpath = 'term://' .. workdir .. '//' .. termcmd


	vim.cmd.tabedit(termpath)
	vim.opt.buflisted = false

	local termbufid = vim.api.nvim_get_current_buf()
	local tabpageid = vim.api.nvim_get_current_tabpage()
	local termwinid = vim.api.nvim_get_current_win()


	---@type integer, integer
	local argswinid, argsbufid
	if showeditwin then
		argswinid = vim.api.nvim_open_win(0, false, {
			split = 'above',
			height = 6,
		})
		vim.api.nvim_set_current_win(argswinid)

		vim.cmd.enew()
		argsbufid = vim.api.nvim_get_current_buf()

		vim.api.nvim_win_set_buf(argswinid, argsbufid)
		vim.opt.buftype = 'nowrite'
		vim.opt.bufhidden = 'hide'
		vim.opt.swapfile = false
		vim.opt.buflisted = false
	else
		argswinid = 0
		argsbufid = 0
	end


	vim.api.nvim_win_set_buf(termwinid, termbufid)


	local instance = setmetatable({
		tabpageid = tabpageid,
		termwinid = termwinid,
		termbufid = termbufid,
		argswinid = argswinid,
		argsbufid = argsbufid,
		prevtabid = prevtabid,
		runconfig = {
			command = command,
			variables = variables,
		},
		workdir = workdir,
	}, TabLayout)


	vim.api.nvim_create_autocmd({ 'BufEnter' }, {
		callback = function()
			local curwinid = vim.api.nvim_get_current_win()
			if curwinid == instance.argswinid then
				vim.api.nvim_win_set_buf(instance.argswinid, instance.argsbufid)
			end
		end
	})

	vim.api.nvim_create_autocmd({ 'BufEnter' }, {
		callback = function()
			local curwinid = vim.api.nvim_get_current_win()
			if curwinid == instance.termwinid then
				vim.api.nvim_win_set_buf(instance.termwinid, instance.termbufid)
			end
		end
	})


	vim.api.nvim_create_autocmd({ 'WinClosed' }, {
		pattern = tostring(instance.termwinid),
		callback = function()
			instance.termwinid = 0
			instance.termbufid = 0
		end
	})


	return instance
end

function TabLayout:gototermwin()
	vim.api.nvim_set_current_win(self.termwinid)
end

function TabLayout:gotoargswin()
	vim.api.nvim_set_current_win(self.argswinid)
end

function TabLayout:run()
	-- Create edit window if not existing.
	if self.argswinid == 0 then
		local argswinid = vim.api.nvim_open_win(0, false, {
			split = 'above',
			height = 6,
		})
		vim.api.nvim_set_current_win(argswinid)
		vim.opt.buflisted = false

		vim.cmd.enew()
		local argsbufid = vim.api.nvim_get_current_buf()

		vim.api.nvim_win_set_buf(argswinid, argsbufid)
		vim.opt.buftype = 'nowrite'
		vim.opt.bufhidden = 'hide'
		vim.opt.swapfile = false
		vim.opt.buflisted = false

		self.argswinid = argswinid
		self.argsbufid = argsbufid
	end


	local curwinid = vim.api.nvim_get_current_win()


	-- Get the content from args buffer.
	vim.api.nvim_set_current_win(self.argswinid)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)


	-- Build terminal command.
	local args = ''
	for _, line in pairs(lines) do
		if line:find('^#') == nil then
			local arg, _ = line:gsub(' #.+', '')
			arg = vim.fn.escape(arg, '#')
			args = args .. ' ' .. vim.trim(arg)
		end
	end
	args = vim.trim(args)

	local termcmd, _ = string.gsub(self.runconfig.command, '<ARGS>', args)
	termcmd = vim.trim(self.runconfig.variables) .. ' ' .. vim.trim(termcmd)


	-- Close current terminal buffer.
	if self.termwinid ~= 0 then
		vim.api.nvim_buf_delete(self.termbufid, { force = true })
	end


	-- Create new terminal buffer.
	local termwinid = vim.api.nvim_open_win(0, false, {
		split = 'below',
	})
	vim.api.nvim_set_current_win(termwinid)

	local termpath = 'term://' .. self.workdir .. '//' .. termcmd
	vim.cmd.edit(termpath)
	vim.opt.buflisted = false

	local termbufid = vim.api.nvim_get_current_buf()
	self.termbufid = termbufid
	self.termwinid = termwinid
	vim.api.nvim_win_set_height(self.argswinid, 6)


	vim.api.nvim_create_autocmd({ 'WinClosed' }, {
		pattern = tostring(self.termwinid),
		callback = function()
			self.termwinid = 0
			self.termbufid = 0
		end
	})


	if curwinid == self.argswinid then
		vim.api.nvim_set_current_win(self.argswinid)
	else
		vim.api.nvim_set_current_win(self.termwinid)
	end
end

function TabLayout:focus()
	if self.meinfocus then
		vim.api.nvim_set_current_tabpage(self.tabpageid)
		self.meinfocus = false
		return
	end


	if not vim.api.nvim_tabpage_is_valid(self.prevtabid) then
		return
	end

	vim.api.nvim_set_current_tabpage(self.prevtabid)
	self.meinfocus = true
end

return TabLayout
