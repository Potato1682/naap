local M = {}

function M.neogen_setup()
  vim.keymap.set("n", "<localleader>d", function()
    require("neogen").generate()
  end, {
    desc = "Generate Document"
  })
end

function M.neogen()
  require("neogen").setup {
    snippet_engine = "luasnip"
  }
end

return M
