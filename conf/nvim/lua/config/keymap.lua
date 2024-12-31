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
vim.keymap.set({ "n", "i" }, "<C-d>", function()
	if #vim.api.nvim_list_wins() == 1 then
		vim.cmd("quit")
	else
		vim.cmd("close")
	end
end, keymapOptions("Close or Quit"))
vim.keymap.set({ "n" }, "fs", "<cmd>lua vim.lsp.buf.format()<cr><cmd>w<cr>", keymapOptions("Format"))
