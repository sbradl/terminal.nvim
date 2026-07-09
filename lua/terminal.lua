local M = {}

local t = require("terminal_handling")
local c = require("commands")

local filetype_commands = {}

local function register(ext, command_list)
	if not filetype_commands[ext] then
		filetype_commands[ext] = {}
	end

	for _, cmd in ipairs(command_list) do
		table.insert(filetype_commands[ext], cmd)
	end
end

register("ts", require("vitest").commands)
register("ts", require("playwright").commands)
register("cs", require("dotnet_test").commands)

M.setup = function() end
M.focus_last_terminal = t.focus_last_terminal
M.open_new_terminal = t.open_new_terminal
M.run_command = function()
	c.choose_and_run_command(filetype_commands)
end

return M
