local M = {}

function M.luasnip()
  require("packs.snip.snippets")
  require("luasnip.loaders.from_vscode").lazy_load()

  local luasnip = require("luasnip")

  local augroup = vim.api.nvim_create_augroup("luasnip-expand", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    pattern = "*:s",
    callback = function()
      if luasnip.in_snippet() then
        return vim.diagnostic.disable()
      end
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    pattern = "[is]:n",
    callback = function()
      if luasnip.in_snippet() then
        return vim.diagnostic.enable()
      end
    end,
  })
end

return M
