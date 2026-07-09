local M = {}

local U = require("util")

M.get_project_dir = function(filename)
	return U.get_parent_dir(filename, "vitest.config.ts")
end

M.commands = {
	ts = {
		{
			label = "vitest current file",
			cmd = function(filename)
				local project_dir = M.get_solution_dir(filename)
				local relative_path = vim.fs.relpath(project_dir, filename)
				return "cd " .. project_dir .. "\nnpx vitest" .. relative_path
			end,
		},
	},
}

return M
