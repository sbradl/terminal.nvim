local focus_last_terminal = require("terminal").focus_last_terminal
local t = require("tests.test_helper")

describe("focus_last_terminal", function() -- Helper function to clean up the workspace before/after tests
	before_each(function()
		t.clear_all_windows_and_buffers()
	end)

	describe("given no terminal is open", function()
		before_each(function()
			t.assert_window_count(1)
			t.focus_non_terminal()
			t.assert_current_window_is_not_terminal()
		end)

		it("should open new terminal in bottom split", function()
			focus_last_terminal()

			t.assert_window_count(2)
		end)

		it("should focus the newly opened terminal", function()
			focus_last_terminal()

			t.assert_current_window_is_terminal()
		end)

		pending("should enter insert mode", function()
			focus_last_terminal()

			t.assert_insert_mode()
		end)
	end)

	describe("given terminal is already open", function()
		before_each(function()
			focus_last_terminal()
			t.assert_window_count(2)
			t.focus_non_terminal()
			t.assert_current_window_is_not_terminal()
		end)

		it("should not open new terminal", function()
			focus_last_terminal()

			t.assert_window_count(2)
		end)

		it("should focus terminal", function()
			focus_last_terminal()

			t.assert_current_window_is_terminal()
		end)
	end)

	describe("given multiple terminals are open", function()
		local rightmost_term_win = nil

		before_each(function()
			vim.cmd("botright vsplit | terminal")
			vim.cmd("botright vsplit | terminal")
			rightmost_term_win = vim.api.nvim_get_current_win()
			t.assert_window_count(3)
		end)

		it("should focus rightmost terminal", function()
			focus_last_terminal()

			assert.equals(rightmost_term_win, vim.api.nvim_get_current_win())
		end)

		pending("should enter insert mode", function()
			focus_last_terminal()

			t.assert_insert_mode()
		end)
	end)
end)
