local editor = {}

editor["ayosec/hltermpaste.vim"] = {
  event = "CursorMoved",

  config = function()
    vim.g.hltermpaste_timeout = 400
  end,
}

editor["ZhiyuanLck/smart-pairs"] = {
  event = "InsertEnter",

  config = function()
    require("packs.editor.config").smartpairs()
  end,
}

editor["RRethy/vim-illuminate"] = {
  event = "BufReadPost",

  module = "illuminate",

  config = function()
    vim.g.Illuminate_delay = 300
  end,
}

editor["folke/which-key.nvim"] = {
  event = { "UIEnter", "BufWinEnter" },

  config = function()
    require("editor.keymap.which-key")
  end,
}

editor["rainbowhxch/accelerated-jk.nvim"] = {
  keys = {
    { "n", "j" },
    { "n", "k" },
  },

  config = function()
    require("packs.editor.config").accelerated_jk()
  end,
}

editor["declancm/cinnamon.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  config = function()
    require("packs.editor.config").cinnamon()
  end,
}

editor["TheBlob42/houdini.nvim"] = {
  event = "InsertEnter",

  config = function()
    require("packs.editor.config").houdini()
  end,
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
  end,
}

editor["chentoast/marks.nvim"] = {
  keys = {
    { "n", "m" },
    { "n", "dm" },
  },

  config = function()
    require("packs.editor.config").marks()
  end,
}

editor["NvChad/nvim-colorizer.lua"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  config = function()
    require("packs.editor.config").colorizer()
  end,
}

editor["gpanders/editorconfig.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead",
    "BufFilePost",
  },
}

editor["numToStr/Comment.nvim"] = {
  event = {
    "CursorMoved",
  },

  config = function()
    require("packs.editor.config").comment()
  end,
}

editor["0styx0/abbreinder.nvim"] = {
  requires = {
    "0styx0/abbremand.nvim",

    module = "abbremand",
  },

  event = {
    "InsertEnter",
    "CmdlineEnter",
  },

  config = function()
    require("packs.editor.config").abbreinder()
  end,
}

editor["kevinhwang91/nvim-hclipboard"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  config = function()
    require("packs.editor.config").hclipboard()
  end,
}

editor["folke/trouble.nvim"] = {
  cmd = {
    "Trouble",
    "TroubleToggle",
  },

  module = "trouble",

  config = function()
    require("packs.editor.config").trouble()
  end,
}

editor["folke/todo-comments.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  setup = function()
    require("packs.editor.config").todo_setup()
  end,

  config = function()
    require("packs.editor.config").todo()
  end,
}

editor["https://gitlab.com/yorickpeterse/nvim-pqf"] = {
  ft = "qf",

  config = function()
    require("packs.editor.config").pqf()
  end,
}

editor["kevinhwang91/nvim-bqf"] = {
  ft = "qf",
}

editor["monaqa/dial.nvim"] = {
  module = "dial",

  setup = function()
    require("packs.editor.config").dial_setup()
  end,

  config = function()
    require("packs.editor.config").dial()
  end,
}

editor["gbprod/stay-in-place.nvim"] = {
  module = "stay-in-place",

  setup = function()
    require("packs.editor.config").stay_in_place_setup()
  end,

  config = function()
    require("packs.editor.config").stay_in_place()
  end,
}

return editor
