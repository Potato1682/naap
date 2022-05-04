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

fold["anuvyklack/pretty-fold.nvim"] = {
  requires = {
    "anuvyklack/nvim-keymap-amend",

    module = "keymap-amend"
  },

  event = "BufReadPost",

  config = function()
    require("packs.fold.config").pretty()
  end
}

return fold

