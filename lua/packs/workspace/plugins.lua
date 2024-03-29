local workspace = {}

workspace["vladdoster/remember.nvim"] = {
  event = "BufWinEnter",

  config = function()
    require("packs.workspace.config").remember()
  end,
}

workspace["rgroli/other.nvim"] = {
  module = "other-nvim",
  cmd = {
    "Other",
    "OtherSplit",
    "OtherVSplit",
  },

  setup = function()
    require("packs.workspace.config").other_setup()
  end,

  config = function()
    require("packs.workspace.config").other()
  end,
}

return workspace
