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
vim.keymap.set({ "n" }, "??", "<cmd>lua require('which-key').show({ global = true })<cr>",
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
vim.keymap.set({ "n" }, "<c-Left>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>", keymapOptions("Navigate Left"))
vim.keymap.set({ "n" }, "<c-Right>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>", keymapOptions("Navigate Right"))
vim.keymap.set({ "n" }, "<c-Up>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>", keymapOptions("Navigate Up"))
vim.keymap.set({ "n" }, "<c-Down>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>", keymapOptions("Navigate Down"))
vim.keymap.set({ "n" }, "<M-Left>", "<cmd>lua require('smart-splits').resize_left()<cr>", keymapOptions("Resize Left"))
vim.keymap.set({ "n" }, "<M-Right>", "<cmd>lua require('smart-splits').resize_right()<cr>", keymapOptions("Resize Right"))
vim.keymap.set({ "n" }, "<M-Up>", "<cmd>lua require('smart-splits').resize_up()<cr>", keymapOptions("Resize Up"))
vim.keymap.set({ "n" }, "<M-Down>", "<cmd>lua require('smart-splits').resize_down()<cr>", keymapOptions("Resize Down"))
vim.keymap.set({ "v" }, "<c-c>", '"+y', keymapOptions("Copy Selection"))
vim.keymap.set({ "i" }, "<c-v>", '<c-r>+', keymapOptions("Paster Clipboard")) 
