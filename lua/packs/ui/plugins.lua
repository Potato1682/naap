local ui = {}
local conf = require("packs.ui.config")

ui["vimpostor/vim-lumen"] = {
  cond = function()
    return not vim.env.TERMUX_VERSION
  end,
  setup = function()
    vim.g.lumen_startup_overwrite = 1
  end
}

ui["olimorris/onedarkpro.nvim"] = {
  config = conf.colorscheme
}

ui["rcarriga/nvim-notify"] = {
  config = conf.notify
}

return ui

