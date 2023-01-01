local M = {}

local null_ls = require("null-ls")

-- sources with no dependencies, no install requirements
M.builtin_sources = {
	null_ls.builtins.code_actions.gitsigns,
	null_ls.builtins.code_actions.gitrebase,
	null_ls.builtins.hover.dictionary,
}

function M.setup()
	null_ls.setup({
		sources = M.builtin_sources,
		on_attach = require("configs.lsp.on_attach").common_on_attach,
	})
end

return M
