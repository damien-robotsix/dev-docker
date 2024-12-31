vim.g.tmux_navigator_no_mappings = 1

return {
	'christoomey/vim-tmux-navigator',
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
	},
	keys = {
		{ "<c-Left>",  "<cmd>TmuxNavigateLeft<cr>" },
		{ "<c-Down>",  "<cmd>TmuxNavigateDown<cr>" },
		{ "<c-Up>",    "<cmd>TmuxNavigateUp<cr>" },
		{ "<c-Right>", "<cmd>TmuxNavigateRight<cr>" },
	},
	keys = {
		{ "<c-Left>",  "<cmd>TmuxNavigateLeft<cr>" },
		{ "<c-Down>",  "<cmd>TmuxNavigateDown<cr>" },
		{ "<c-Up>",    "<cmd>TmuxNavigateUp<cr>" },
		{ "<c-Right>", "<cmd>TmuxNavigateRight<cr>" },
		{ "<c-S-Left>",  "<cmd>vertical resize -5<cr>" },
		{ "<c-S-Right>", "<cmd>vertical resize +5<cr>" },
		{ "<c-S-Up>",    "<cmd>resize -5<cr>" },
		{ "<c-S-Down>",  "<cmd>resize +5<cr>" },
	},
}
