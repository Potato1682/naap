local workspace = {}

workspace["vladdoster/remember.nvim"] = {
  event = "BufWinEnter",

  config = function()
    require("packs.workspace.config").remember()
  end
}

workspace["olimorris/persisted.nvim"] = {
  config = function()
    require("packs.workspace.config").persisted()
  end
}

return workspace
