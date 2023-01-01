local backup = {}

backup["aiya000/aho-bakaup.vim"] = {
  event = {
    "BufWritePre",
  },

  setup = function()
    require("packs.backup.config").bakaup_setup()
  end,
}

backup["mbbill/undotree"] = {
  cmd = "UndotreeToggle",

  setup = function()
    require("packs.backup.config").undotree_setup()
  end,
}

return backup
