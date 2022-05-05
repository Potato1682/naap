local editor = {}

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
    require("configs.keymap")
  end
}

editor["gpanders/editorconfig.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead"
  }
}

return editor