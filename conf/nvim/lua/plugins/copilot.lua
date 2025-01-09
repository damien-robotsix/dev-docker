-- Set copilot workspace to current directory
vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

return {
	"github/copilot.vim"
}
