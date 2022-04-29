local fold = {}
local conf = require("packs.fold.config")

fold["jghauser/fold-cycle.nvim"] = {
  module = "fold-cycle",

  setup = conf.cycle_setup,
  config = conf.cycle
}

fold["anuvyklack/pretty-fold.nvim"] = {
  event = "BufReadPre",

  config = conf.pretty
}

return fold

