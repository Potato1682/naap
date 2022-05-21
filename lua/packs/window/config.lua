local M = {}

function M.stabilize()
  require("stabilize").setup()
end

function M.split_setup()
  vim.keymap.set("n", "ss", "<cmd>Split<cr>", {
    desc = "Split Window"
  })
end

function M.split()
  local abbrev = require("utils.abbreviation").abbrev

  require("autosplit").setup {
    split = "auto"
  }

  abbrev("c", "sp", "Split")
  abbrev("c", "split", "Split")
end

return M
