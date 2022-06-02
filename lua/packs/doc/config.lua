local M = {}

function M.neogen_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<localleader>d", function()
    require("neogen").generate()
  end, "Generate Document")
end

function M.neogen()
  require("neogen").setup {
    snippet_engine = "luasnip"
  }
end

return M
