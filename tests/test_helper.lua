local M = {}

M.assert_window_count = function(expected_count)
	local windows = vim.api.nvim_list_wins()
	assert.equals(expected_count, #windows)
end

M.assert_current_window_is_not_terminal = function()
	local current_buf = vim.api.nvim_get_current_buf()
	assert.not_equals("terminal", vim.bo[current_buf].buftype)
end

M.assert_current_window_is_terminal = function()
	local current_buf = vim.api.nvim_get_current_buf()
	assert.equals("terminal", vim.bo[current_buf].buftype)
end

M.assert_insert_mode = function()
	assert.equals("i", vim.api.nvim_get_mode().mode)
end

M.focus_non_terminal = function()
	local windows = vim.api.nvim_list_wins()
	vim.api.nvim_set_current_win(windows[1])
	M.assert_current_window_is_not_terminal()
end

M.clear_all_windows_and_buffers = function()
	local initial_win = vim.api.nvim_get_current_win()

	-- Create a safe dummy buffer and window so we don't accidentally close Neovim
	local safe_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(safe_buf)

	-- Close all other windows
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= initial_win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Clean up terminal buffers left over from previous tests
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

return M
