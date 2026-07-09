local M = {}

M.get_solution_dir = function(filename)
	local sln_dir = vim.fs.find(function(name)
		return name:match("%.slnx?$")
	end, { path = vim.fs.dirname(filename), limit = 1, upward = true, type = "file" })[1]

	return vim.fs.dirname(sln_dir)
end

M.get_namespace = function(_, buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for _, line in ipairs(lines) do
		local namespace = line:match("^%s*namespace%s+([%w%.]+)")
		if namespace then
			return namespace
		end
	end

	return nil
end

M.commands = {
	cs = {
		{
			label = "dotnet test current file",
			cmd = function(filename)
				local sln_dir = M.get_solution_dir(filename)
				return "cd " .. sln_dir .. "\ndotnet test --filter ClassName~" .. vim.fn.fnamemodify(filename, ":t:r")
			end,
		},
		{
			label = "dotnet test current namespace",
			cmd = function(filename, buf)
				local sln_dir = M.get_solution_dir(filename)
				local ns = M.get_namespace(filename, buf)
				return "cd " .. sln_dir .. "\ndotnet test --filter FullyQualifiedName~" .. ns
			end,
		},
	},
}

return M
