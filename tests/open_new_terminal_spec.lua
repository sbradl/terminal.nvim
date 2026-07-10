local open_new_terminal = require("terminal").open_new_terminal
local t = require("tests.test_helper")

describe("open_new_terminal", function()
	before_each(function()
		t.clear_all_windows_and_buffers()
	end)

	before_each(function()
		t.assert_window_count(1)
		t.focus_non_terminal()
		t.assert_current_window_is_not_terminal()
	end)

	it("should open new terminal in bottom split", function()
		open_new_terminal()

		t.assert_window_count(2)
	end)

	it("should focus the newly opened terminal", function()
		open_new_terminal()

		t.assert_current_window_is_terminal()
	end)

	pending("should enter insert mode", function()
		open_new_terminal()

		t.assert_insert_mode()
	end)

	it("should open new terminals everytime", function()
		open_new_terminal()
		open_new_terminal()

		t.assert_window_count(3)
	end)

	describe("given a directory argument", function()
		it("should open terminal in that directory", function()
			local dir = t.testdata("otherdir")

			open_new_terminal(dir)

			t.assert_terminal_cwd(dir)
		end)

		it("should prefer the argument over the current file's directory", function()
			vim.cmd("edit " .. t.testdata("project/src/main.lua"))
			local dir = t.testdata("otherdir")

			open_new_terminal(dir)

			t.assert_terminal_cwd(dir)
		end)
	end)

	describe("given current buffer is file", function()
		it("should open terminal in directory of file", function()
			vim.cmd("edit " .. t.testdata("project/src/main.lua"))

			open_new_terminal()

			t.assert_terminal_cwd(t.testdata("project/src"))
		end)
	end)

	describe("given current buffer is not associated with file", function()
		it("should open terminal in current working directory", function()
			t.assert_current_window_is_not_terminal()

			open_new_terminal()

			t.assert_terminal_cwd(vim.fn.getcwd(-1, -1))
		end)
	end)

	describe("given current buffer is a terminal", function()
		it("should open terminal in current working directory", function()
			open_new_terminal(t.testdata("otherdir"))
			t.assert_current_window_is_terminal()

			open_new_terminal()

			t.assert_terminal_cwd(vim.fn.getcwd(-1, -1))
		end)
	end)
end)
