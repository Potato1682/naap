local explorer = {}

explorer["nvim-neo-tree/neo-tree.nvim"] = {
  cmd = "Neotree",

  module = "neo-tree",

  setup = function()
    require("packs.explorer.config").neotree_setup()
  end,

  config = function()
    require("packs.explorer.config").neotree()
  end,
}

return explorer
