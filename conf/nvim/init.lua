vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
vim.opt.signcolumn = "yes"
vim.opt.number = true

require("config.lazy")

vim.cmd("colorscheme tokyonight-moon")

require("config.keymap")

local cmp = require('cmp')

cmp.setup({
	sources = {
		{ name = 'nvim_lsp', group_index = 2 },
	},
	snippet = {
		expand = function(args)
			-- You need Neovim v0.10 to use vim.snippet
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
})
