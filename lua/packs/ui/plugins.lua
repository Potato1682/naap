local ui = {}
local helper = require("packs.helper")

ui["catppuccin/nvim"] = {
  as = "catppuccin",

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

ui["folke/noice.nvim"] = {
  requires = {
    { "MunifTanjim/nui.nvim" },
    {
      "rcarriga/nvim-notify",

      module = "notify",

      config = function()
        require("packs.ui.config").notify()
      end
    }
  },

  wants = { "nvim-treesitter" },

  event = {
    "BufRead",
    "BufNewFile",
    "InsertEnter",
    "CmdlineEnter"
  },

  module = "noice",

  setup = function()
    if not _G.__vim_notify_overwritten then
      vim.notify = function(...)
        local arg = { ... }

        require("notify")
        require("noice")

        vim.schedule(function()
          if args ~= nil then
            vim.notify(unpack(args))
          end
        end)
      end

      _G.__vim_notify_overwritten = true
    end
  end,

  config = function()
    require("packs.ui.config").noice()
  end
}

ui["nvim-lualine/lualine.nvim"] = {
  requires = {
    { "kyazdani42/nvim-web-devicons", opt = true }
  },

  wants = {
    "nvim-web-devicons"
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
    { "kyazdani42/nvim-web-devicons", opt = true }
  },

  wants = {
    "catppuccin",
    "nvim-web-devicons"
  },

  event = "BufWinEnter",

  cond = helper.in_vscode,

  config = function()
    require("packs.ui.config").bufferline()
  end
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
