local M = {}

local t = require("terminal_handling")
local c = require("commands")

M._filetype_commands = {}

M.register = function(ext, command_list)
	if not M._filetype_commands[ext] then
		M._filetype_commands[ext] = {}
	end

	for _, cmd in ipairs(command_list) do
		table.insert(M._filetype_commands[ext], cmd)
	end
end

M.register("ts", require("vitest").commands)
M.register("ts", require("playwright").commands)
M.register("cs", require("dotnet_test").commands)

M.setup = function(opts)
	opts = opts or {}

	if opts.commands then
		for ext, command_list in pairs(opts.commands) do
			M.register(ext, command_list)
		end
	end
end

M.focus_last_terminal = t.focus_last_terminal
M.open_new_terminal = t.open_new_terminal
M.run_command = function()
	c.choose_and_run_command(M._filetype_commands)
end

return M
