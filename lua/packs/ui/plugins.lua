local ui = {}
local helper = require("packs.helper")

ui["MunifTanjim/nui.nvim"] = {
  module = "nui"
}

ui["vimpostor/vim-lumen"] = {
  after = "onedarkpro.nvim",

  cond = function()
    require("packs.ui.config").lumen_cond()
  end,

  setup = function()
    vim.g.lumen_startup_overwrite = 0
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

ui["stevearc/dressing.nvim"] = {
  event = "UIEnter",

  config = function()
    require("packs.ui.config").dressing()
  end
}

ui["rcarriga/nvim-notify"] = {
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

ui["lewis6991/satellite.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost"
  },

  cond = helper.in_vscode,

  run = function()
    vim.cmd("packadd satellite.nvim")

    require("satellite").setup()
  end,

  config = function()
    require("satellite").setup()
  end
}

ui["lukas-reineke/indent-blankline.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead"
  },

  cond = helper.in_vscode,

  config = function()
    require("packs.ui.config").indent_blankline()
  end
}

ui["lukas-reineke/virt-column.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead"
  },

  cond = helper.in_vscode,

  config = function()
    require("virt-column").setup()
  end
}

return ui
