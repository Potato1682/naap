local cmdline = {}

cmdline["nacro90/numb.nvim"] = {
  event = "CmdlineEnter",

  config = function()
    require("packs.cmdline.config").numb()
  end
}

cmdline["winston0410/cmd-parser.nvim"] = {
  event = "CmdlineEnter"
}

cmdline["winston0410/range-highlight.nvim"] = {
  after = "cmd-parser.nvim",

  config = function()
    require("packs.cmdline.config").range_highlight()
  end
}


return cmdline
