local editor = {}

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

