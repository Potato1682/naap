local ui = {}

ui["catppuccin/nvim"] = {
  as = "catppuccin",

  config = function()
    require("packs.ui.config").colorscheme()
  end,
}

ui["stevearc/dressing.nvim"] = {
  event = "UIEnter",

  config = function()
    require("packs.ui.config").dressing()
  end,
}

ui["folke/noice.nvim"] = {
  requires = {
    { "MunifTanjim/nui.nvim" },
    {
      "rcarriga/nvim-notify",

      module = "notify",

      config = function()
        require("packs.ui.config").notify()
      end,
    },
  },

  event = {
    "BufRead",
    "BufNewFile",
    "InsertEnter",
    "CmdlineEnter",
  },

  module = "noice",

  setup = function()
    require("packs.ui.config").noice_setup()
  end,

  config = function()
    require("packs.ui.config").noice()
  end,
}

ui["nvim-lualine/lualine.nvim"] = {
  requires = {
    { "nvim-tree/nvim-web-devicons", opt = true },
  },

  wants = {
    "nvim-web-devicons",
  },

  event = "UIEnter",

  run = function()
    vim.cmd("packadd lualine.nvim")

    require("configs.lualine")
  end,

  config = function()
    require("configs.lualine")
  end,
}

ui["akinsho/bufferline.nvim"] = {
  requires = {
    { "nvim-tree/nvim-web-devicons", opt = true },
  },

  wants = {
    "catppuccin",
    "nvim-web-devicons",
  },

  event = "BufWinEnter",

  config = function()
    require("packs.ui.config").bufferline()
  end,
}

ui["lewis6991/satellite.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  run = function()
    vim.cmd("packadd satellite.nvim")

    require("satellite").setup()
  end,

  config = function()
    require("satellite").setup()
  end,
}

ui["utilyre/barbecue.nvim"] = {
  requires = {
    { "nvim-tree/nvim-web-devicons", opt = true },
  },

  wants = {
    "nvim-web-devicons",
  },

  event = {
    "BufNewFile",
    "BufRead",
  },

  config = function()
    require("packs.ui.config").barbecue()
  end,
}

ui["lukas-reineke/indent-blankline.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  config = function()
    require("packs.ui.config").indent_blankline()
  end,
}

ui["lukas-reineke/virt-column.nvim"] = {
  event = {
    "BufNewFile",
    "BufRead",
  },

  config = function()
    require("virt-column").setup()
  end,
}

return ui
