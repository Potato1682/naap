local workspace = {}

workspace["vladdoster/remember.nvim"] = {
  event = "BufWinEnter",

  config = function()
    require("packs.workspace.config").remember()
  end
}

workspace["rgroli/other.nvim"] = {
  module = "other-nvim",
  cmd = {
    "Other",
    "OtherSplit",
    "OtherVSplit"
  },

  setup = function()
    require("packs.workspace.config").other_setup()
  end,

  config = function()
    require("packs.workspace.config").other()
  end
}

workspace["olimorris/persisted.nvim"] = {
  config = function()
    require("packs.workspace.config").persisted()
  end
}

return workspace
