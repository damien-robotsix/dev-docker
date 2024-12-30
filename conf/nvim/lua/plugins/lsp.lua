return {
	{
		"dundalek/lazy-lsp.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			require("lazy-lsp").setup {
				capabilities = capabilities
			}
		end
	},
}
