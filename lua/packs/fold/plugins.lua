local fold = {}

fold["jghauser/fold-cycle.nvim"] = {
  module = "fold-cycle",

  setup = function()
    require("packs.fold.config").cycle_setup()
  end,

  config = function()
    require("packs.fold.config").cycle()
  end,
}

fold["kevinhwang91/nvim-ufo"] = {
  requires = {
    { "kevinhwang91/promise-async", opt = true },
  },

  wants = {
    "promise-async",
  },

  after = "nvim-treesitter", -- It's a dependency of nvim-treesitter

  event = "BufReadPost",

  config = function()
    require("packs.fold.config").ufo()
  end,
}

return fold
