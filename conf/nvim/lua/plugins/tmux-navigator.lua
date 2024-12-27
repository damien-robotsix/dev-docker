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
}
