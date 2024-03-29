local window = {}

window["yochem/autosplit.nvim"] = {
  cmd = "Split",

  setup = function()
    require("packs.window.config").split_setup()
  end,

  config = function()
    require("packs.window.config").split()
  end,
}

window["tenxsoydev/size-matters.nvim"] = {
  keys = {
    "<C-+>",
    "<C-S-+>",
    "<C-->",
    "<C-ScrollWheelUp>",
    "<C-ScrollWheelDown>",
    "<A-C-=>",
  },
}

window["nvim-zh/colorful-winsep.nvim"] = {
  event = {
    "WinNew",
    "WinClosed",
    "BufWinEnter",
  },

  config = function()
    require("packs.window.config").colorful_winsep()
  end,
}

return window
