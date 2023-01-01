local M = {}

function M.neodev()
	require("neodev").setup({
		lspconfig = false,
	})
end

return M
