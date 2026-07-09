local M = {}

local function rightmost_terminal()
	local rightmost_win = nil
	local max_col = -1

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].buftype == "terminal" then
			local pos = vim.fn.win_screenpos(vim.fn.win_id2win(win))
			local col = pos[2] -- {row, col}

			if col > max_col then
				max_col = col
				rightmost_win = win
			end
		end
	end

	return rightmost_win
end

local function open_terminal(split_command, source_buf, dir)
	local dir_to_use

	if dir ~= nil then
		dir_to_use = dir
	else
		local name = vim.api.nvim_buf_get_name(source_buf)
		if name ~= "" and vim.bo[source_buf].buftype ~= "terminal" then
			dir_to_use = vim.fn.fnamemodify(name, ":p:h")
		else
			dir_to_use = vim.fn.getcwd(-1, -1)
		end
	end

	vim.cmd(split_command)
	vim.cmd("lcd " .. vim.fn.fnameescape(dir_to_use))
	vim.cmd("terminal")
	vim.cmd("startinsert")
end

M.focus_last_terminal = function()
	local source_buf = vim.api.nvim_get_current_buf()
	local win = rightmost_terminal()

	if win then
		vim.api.nvim_set_current_win(win)
		vim.cmd("startinsert")
	else
		open_terminal("botright 20split", source_buf)
	end
end

M.open_new_terminal = function(dir)
	local source_buf = vim.api.nvim_get_current_buf()
	local win = rightmost_terminal()

	if win then
		vim.api.nvim_set_current_win(win)
		open_terminal("vsplit", source_buf, dir)
	else
		open_terminal("botright 20split", source_buf, dir)
	end
end

return M
