return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup {
				signs = true,
				highlight = {
					comments_only = false,
				},
			}
		end,
	},
	{
		"nvim-lua/plenary.nvim",
	},
}
