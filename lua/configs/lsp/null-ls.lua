local M = {}

function M.setup()
  local null_ls = require("null-ls")

  local sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.gitrebase,
    null_ls.builtins.hover.dictionary
  }

  for _, formatter in ipairs(require("format-installer").get_installed_formatters()) do
    local config = {
      command = formatter.cmd
    }

    table.insert(sources, null_ls.builtins.formatting[formatter.name].with(config))
  end

  null_ls.setup {
    sources = sources,
    on_attach = require("configs.lsp.on_attach").common_on_attach
  }
end

return M
