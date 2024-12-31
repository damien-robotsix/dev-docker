local function keymapOptions(desc)
	return {
		noremap = true,
		silent = true,
		nowait = true,
		desc = desc,
	}
end

vim.keymap.set({ "n" }, "--", "<cmd>split<cr>", keymapOptions("Horizontal split"))
vim.keymap.set({ "n" }, "||", "<cmd>vsplit<cr>", keymapOptions("Vertical split"))
vim.keymap.set({ "n" }, "??", require('which-key').show({ global = true }),
	keymapOptions("Buffer local Keymaps with which-key"))
vim.keymap.set({ "n", "i" }, "<C-d>", function()
	local current_win = vim.api.nvim_get_current_win()
	local has_popup = false
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, true)
			has_popup = true
			break
		end
	end
	if not has_popup then
		if #vim.api.nvim_list_wins() == 1 then
			vim.cmd("quit")
		else
			vim.cmd("close")
		end
	end
end, keymapOptions("Close Popup or Quit"))
vim.keymap.set({ "n" }, "fs", "<cmd>lua vim.lsp.buf.format()<cr><cmd>w<cr>", keymapOptions("Format"))
vim.keymap.set({ "n" }, "<c-Left>", require('smart-splits').move_cursor_left, keymapOptions("Navigate Left"))
vim.keymap.set({ "n" }, "<c-Right>", require('smart-splits').move_cursor_right, keymapOptions("Navigate Right"))
vim.keymap.set({ "n" }, "<c-Up>", require('smart-splits').move_cursor_up, keymapOptions("Navigate Up"))
vim.keymap.set({ "n" }, "<c-Down>", require('smart-splits').move_cursor_down, keymapOptions("Navigate Down"))
vim.keymap.set({ "n" }, "<c-S-Left>", require('smart-splits').resize_left, keymapOptions("Resize Left"))
vim.keymap.set({ "n" }, "<c-S-Right>", require('smart-splits').resize_right, keymapOptions("Resize Right"))
vim.keymap.set({ "n" }, "<c-S-Up>", require('smart-splits').resize_up, keymapOptions("Resize Up"))
vim.keymap.set({ "n" }, "<c-S-Down>", require('smart-splits').resize_down, keymapOptions("Resize Down"))

