-- Set copilot workspace to current directory
vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

return {
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true },
				panel = { enabled = true },
				filetypes = {
					["*"] = true,
				},
			})
		end
	},
}
