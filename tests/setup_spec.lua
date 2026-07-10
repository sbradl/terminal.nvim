local terminal = require("terminal")
local t = require("tests.test_helper")

describe("setup", function()
	before_each(function()
		t.clear_all_windows_and_buffers()
	end)

	after_each(function()
		-- Restore the default so the shared config does not leak into later tests.
		terminal.setup({ size = 20 })
	end)

	it("should use a default split height when no size is configured", function()
		terminal.open_new_terminal()

		t.assert_window_height(20)
	end)

	it("should use the configured size as the split height", function()
		terminal.setup({ size = 8 })

		terminal.open_new_terminal()

		t.assert_window_height(8)
	end)

	it("should keep unspecified options at their defaults", function()
		terminal.setup({})

		terminal.open_new_terminal()

		t.assert_window_height(20)
	end)
end)