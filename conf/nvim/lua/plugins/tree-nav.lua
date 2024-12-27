local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.del('n', '<C-k>', { buffer = bufnr })
	vim.keymap.del('n', '<Tab>', { buffer = bufnr })
end

return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<Tab>", ":NvimTreeToggle<CR>", desc = "Tree toogle" },
		},
		config = function()
			require("nvim-tree").setup {
				view = {
					width = 40,
					adaptive_size = false,
				},
				on_attach = my_on_attach
			}
		end,
	},
}
