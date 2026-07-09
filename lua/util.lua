local M = {}

M.get_parent_dir = function(filename, search_pattern)
	local sln_dir = vim.fs.find(function(name)
		return name:match(search_pattern)
	end, { path = vim.fs.dirname(filename), limit = 1, upward = true, type = "file" })[1]

	return vim.fs.dirname(sln_dir)
end

return M
