local ui = {}
local helper = require("packs.helper")

ui["vimpostor/vim-lumen"] = {
  after = "onedarkpro.nvim",

  cond = function()
    require("packs.ui.config").lumen_cond()
  end,

  setup = function()
    require("packs.ui.config").lumen_setup()
  end
}

ui["olimorris/onedarkpro.nvim"] = {
  event = "UIEnter",

  run = function()
    vim.cmd("packadd onedarkpro.nvim")
    require("packs.ui.config").colorscheme()

    if require("packs.ui.config").lumen_cond() then
      require("packs.ui.config").lumen_setup()
      vim.cmd("packadd vim-lumen")
    end
  end,

  cond = helper.in_vscode,

  config = function()
    require("packs.ui.config").colorscheme()
  end
}

ui["rcarriga/nvim-notify"] = {
  event = "UIEnter",

  cond = helper.in_vscode,

  config = function()
    require("packs.ui.config").notify()
  end
}

ui["nvim-lualine/lualine.nvim"] = {
  requires = {
    "kyazdani42/nvim-web-devicons",

    opt = true
  },

  event = "UIEnter",

  run = function()
    vim.cmd("packadd lualine.nvim")

    require("configs.lualine")
  end,

  cond = helper.in_vscode,

  config = function()
    require("configs.lualine")
  end
}

ui["akinsho/bufferline.nvim"] = {
  requires = {
    "kyazdani42/nvim-web-devicons",

    opt = true
  },

  tag = "*",

  event = "UIEnter",

  run = function()
    vim.cmd("packadd bufferline.nvim")

    require("packs.ui.config").bufferline()
  end,

  cond = helper.in_vscode,

  config = function()
    require("packs.ui.config").bufferline()
  end,
}

return ui

