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
vim.keymap.set({ "n", "i" }, "<C-d>", "<cmd>close<cr>", keymapOptions("Close"))
vim.keymap.set({ "n" }, "fs", "<cmd>lua vim.lsp.buf.format()<cr><cmd>w<cr>", keymapOptions("Format"))

