local M = {}

local t = require("terminal_handling")
local c = require("commands")
local cs = require("cs")

local filetype_commands = vim.tbl_deep_extend("force", cs.commands)

M.setup = function() end
M.focus_last_terminal = t.focus_last_terminal
M.open_new_terminal = t.open_new_terminal
M.run_command = function()
	c.choose_and_run_command(filetype_commands)
end

return M
