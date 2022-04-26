local ui = {}
local conf = require("packs.ui.config")

ui["vimpostor/vim-lumen"] = {
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

