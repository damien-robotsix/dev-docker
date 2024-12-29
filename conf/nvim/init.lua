vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
vim.opt.signcolumn = "yes"
vim.opt.number = true

require("config.lazy")
require("config.keymap")

vim.cmd("colorscheme tokyonight-moon")
