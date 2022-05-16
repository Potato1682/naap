local M = {}

function M.setup()
  local null_ls = require("null-ls")

  local sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.gitrebase,
    null_ls.builtins.hover.dictionary
  }

  null_ls.setup {
    sources = sources,
    on_attach = require("configs.lsp.on_attach").common_on_attach
  }
end

return M
