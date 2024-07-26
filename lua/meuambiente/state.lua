local M = {
	---@type TerminalBuffer[]
	termbuffers = {},

	---@type integer | nil
	lastfileid = 1,

	---@type TabLayout[]
	tablayouts = {},

	---@type Config
	config = {},
}



---Close the terminal buffer with the given id.
---@param termid integer
M.close_termbuffer = function(termid)
	for key, termbuffer in pairs(M.termbuffers) do
		if termbuffer.termid == termid then
			vim.api.nvim_buf_delete(termbuffer.termid, { force = true })
			M.termbuffers[key] = nil
		end
	end
end



return M
