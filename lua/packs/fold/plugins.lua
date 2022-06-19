local fold = {}
local conf = require("packs.fold.config")

fold["jghauser/fold-cycle.nvim"] = {
  module = "fold-cycle",

  setup = function()
    require("packs.fold.config").cycle_setup()
  end,
  config = function()
    require("packs.fold.config").cycle()
  end
}

fold["kevinhwang91/nvim-ufo"] = {
  event = "BufReadPost",

  config = function()
    require("packs.fold.config").ufo()
  end
}

return fold

