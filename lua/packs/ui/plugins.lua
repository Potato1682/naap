local ui = {}
local helper = require("packs.helper")
local conf = require("packs.ui.config")

ui["vimpostor/vim-lumen"] = {
  cond = function()
    return not vim.env.TERMUX_VERSION or helper.in_vscode()
  end,

  setup = function()
    vim.g.lumen_startup_overwrite = 1
  end
}

ui["olimorris/onedarkpro.nvim"] = {
  cond = helper.in_vscode,
  config = conf.colorscheme
}

ui["rcarriga/nvim-notify"] = {
  cond = helper.in_vscode,
  config = conf.notify
}

ui["nvim-lualine/lualine.nvim"] = {
  requires = {
    "kyazdani42/nvim-web-devicons",

    opt = true
  },

  cond = helper.in_vscode,

  config = function()
    require("configs.lualine")
  end
}

return ui

