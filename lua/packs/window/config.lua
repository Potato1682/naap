local M = {}

function M.stabilize()
  require("stabilize").setup()
end

function M.split_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "ss", "<cmd>Split<cr>", "Split Window")
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
