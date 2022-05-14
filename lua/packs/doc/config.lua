local M = {}

function M.neogen()
  require("neogen").setup {
    snippet_engine = "luasnip"
  }
end

return M
