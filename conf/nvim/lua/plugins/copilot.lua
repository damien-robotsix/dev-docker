-- Set copilot workspace to current directory
vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

return {
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					["*"] = true,
				},
			})
		end
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("copilot_cmp").setup()
		end
	}
}
