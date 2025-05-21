return {
	{
		"yetone/avante.nvim",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			provider = "openrouter",
			vendors = {
				["openrouter"] = {
					__inherited_from = "openai",
					endpoint = "https://api.openrouter.ai/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "google/gemini-2.5-pro-preview",
				},
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	}
}
