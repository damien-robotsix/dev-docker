return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"??",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer local Keymaps with which-key"
			}
		},
	}
}
