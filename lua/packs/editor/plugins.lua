local editor = {}

editor["ZhiyuanLck/smart-pairs"] = {
  event = "InsertEnter",

  config = function()
    require("packs.editor.config").smartpairs()
  end
}

editor["RRethy/vim-illuminate"] = {
  event = "BufEnter",

  config = function()
    vim.g.Illuminate_delay = 300
  end
}

editor["kevinhwang91/nvim-hlslens"] = {
  event = "CmdlineEnter",
  module = "hlslens",

  setup = function()
    require("packs.editor.config").hlslens_setup()
  end,

  config = function()
    require("packs.editor.config").hlslens()
  end
}

editor["max397574/which-key.nvim"] = {
  event = "UIEnter",

  config = function()
    require("keymap.which-key")
  end
}

editor["rainbowhxch/accelerated-jk.nvim"] = {
  keys = {
    { "n", "j" },
    { "n", "k" }
  },

  config = function()
    require("packs.editor.config").accelerated_jk()
  end
}

editor["declancm/cinnamon.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost"
  },

  config = function()
    require("packs.editor.config").cinnamon()
  end
}

editor["TheBlob42/houdini.nvim"] = {
  event = "InsertEnter",

  config = function()
    require("packs.editor.config").houdini()
  end
}

editor["kevinhwang91/nvim-fFHighlight"] = {
  keys = {
    { "n", "f" },
    { "n", "F" },
    { "x", "f" },
    { "x", "F" },
  },

  config = function()
    require("packs.editor.config").fF_highlight()
  end
}

editor["nacro90/numb.nvim"] = {
  event = "CmdlineEnter",

  config = function()
    require("packs.editor.config").numb()
  end
}

editor["winston0410/cmd-parser.nvim"] = {
  event = "CmdlineEnter"
}

editor["winston0410/range-highlight.nvim"] = {
  after = "cmd-parser.nvim",

  config = function()
    require("packs.editor.config").range_highlight()
  end
}

editor["gpanders/editorconfig.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead"
  }
}

editor["numToStr/Comment.nvim"] = {
  event = {
    "CursorMoved"
  },

  config = function()
    require("packs.editor.config").comment()
  end
}

return editor
