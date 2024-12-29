vim.opt.autoread = true
vim.opt.signcolumn = "yes"
vim.opt.number = true

require("config.lazy")
require("config.keymap")

vim.cmd("colorscheme tokyonight-moon")
