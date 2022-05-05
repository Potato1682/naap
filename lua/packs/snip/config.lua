local M = {}

function M.luasnip()
  require("packs.snip.snippets")
  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
