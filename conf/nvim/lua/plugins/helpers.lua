return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		config = function()
			require("smart-splits").setup({
			})
		end
	},
	{
		"folke/which-key.nvim",
		event = "lazy",
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		}
	}
}
