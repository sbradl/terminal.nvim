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
end)
