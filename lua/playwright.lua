local M = {}

M.get_project_dir = function(filename)
	return vim.fs.root(filename, { "playwright.config.ts" })
end

M.commands = {
	ts = {
		{
			filter = function(filename)
				return M.get_project_dir(filename) ~= nil
			end,
			label = "Playwright current file",
			cmd = function(filename)
				local project_dir = M.get_project_dir(filename)
				return "cd " .. project_dir .. "\nnpx playwright test"
			end,
		},
	},
}

return M
