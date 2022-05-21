local M = {}

local null_ls = require("null-ls")

-- sources with no dependencies, no install requirements
M.builtin_sources = {
  null_ls.builtins.code_actions.gitsigns,
  null_ls.builtins.code_actions.gitrebase,
  null_ls.builtins.hover.dictionary
}

function M.add_formatters()
  local formatters = {}

  for _, formatter in ipairs(require("format-installer").get_installed_formatters()) do
    local config = {
      command = formatter.cmd
    }

    table.insert(formatters, null_ls.builtins.formatting[formatter.name].with(config))
  end

  return formatters
end

function M.setup()
  null_ls.setup {
    sources = vim.list_extend(
      M.builtin_sources,
      M.add_formatters()
    ),
    on_attach = require("configs.lsp.on_attach").common_on_attach
  }
end

return M
