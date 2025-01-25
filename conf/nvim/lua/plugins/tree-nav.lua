local function my_on_attach(bufnr)
	local function grep_in(node)
		if not node then
			return
		end
		local path = node.absolute_path
		if node.type ~= 'directory' and node.parent then
			path = node.parent.absolute_path
		end
		require('telescope.builtin').live_grep({
			search_dirs = { path },
			prompt_title = string.format('Grep in [%s]', vim.fs.basename(path)),
		})
	end

	local api = require "nvim-tree.api"

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.del('n', '<C-k>', { buffer = bufnr })
	vim.keymap.del('n', '<Tab>', { buffer = bufnr })
	vim.keymap.set('n', '<C-f>', function()
		local node = api.tree.get_node_under_cursor()
		grep_in(node)
	end, { buffer = bufnr, desc = 'Grep in current directory' })
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
