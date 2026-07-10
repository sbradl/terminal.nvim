local focus_last_terminal = require("terminal").focus_last_terminal

local function assert_window_count(expected_count)
	local windows = vim.api.nvim_list_wins()
	assert.equals(expected_count, #windows)
end

local function assert_current_window_is_not_terminal()
	local current_buf = vim.api.nvim_get_current_buf()
	assert.not_equals("terminal", vim.bo[current_buf].buftype)
end

local function assert_current_window_is_terminal()
	local current_buf = vim.api.nvim_get_current_buf()
	assert.equals("terminal", vim.bo[current_buf].buftype)
end

local function assert_insert_mode()
	assert.equals("i", vim.api.nvim_get_mode().mode)
end

local function focus_non_terminal()
	local windows = vim.api.nvim_list_wins()
	vim.api.nvim_set_current_win(windows[1])
	assert_current_window_is_not_terminal()
end

describe("focus_last_terminal", function() -- Helper function to clean up the workspace before/after tests
	local function clear_all_windows_and_buffers()
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

	before_each(function()
		clear_all_windows_and_buffers()
	end)

	describe("given no terminal is open", function()
		before_each(function()
			assert_window_count(1)
			focus_non_terminal()
			assert_current_window_is_not_terminal()
		end)

		it("should open new terminal in bottom split", function()
			focus_last_terminal()

			assert_window_count(2)
		end)

		it("should focus the newly opened terminal", function()
			focus_last_terminal()

			assert_current_window_is_terminal()
		end)

		pending("should enter insert mode", function()
			focus_last_terminal()

			assert_insert_mode()
		end)
	end)

	describe("given terminal is already open", function()
		before_each(function()
			focus_last_terminal()
			assert_window_count(2)
			focus_non_terminal()
			assert_current_window_is_not_terminal()
		end)

		it("should not open new terminal", function()
			focus_last_terminal()

			assert_window_count(2)
		end)

		it("should focus terminal", function()
			focus_last_terminal()

			assert_current_window_is_terminal()
		end)
	end)

	describe("given multiple terminals are open", function()
		local rightmost_term_win = nil

		before_each(function()
			vim.cmd("botright vsplit | terminal")
			vim.cmd("botright vsplit | terminal")
			rightmost_term_win = vim.api.nvim_get_current_win()
			assert_window_count(3)
		end)

		it("should focus rightmost terminal", function()
			focus_last_terminal()

			assert.equals(rightmost_term_win, vim.api.nvim_get_current_win())
		end)

		pending("should enter insert mode", function()
			focus_last_terminal()

			assert_insert_mode()
		end)
	end)
end)
