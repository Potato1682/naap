local window = {}

window["luukvbaal/stabilize.nvim"] = {
  events = {
    "WinNew",
    "WinClosed",
    "BufWinEnter",
    "CursorMoved",
    "CursorMovedI",
    "User StabilizeRestore"
  },

  config = function()
    require("packs.window.config").stabilize()
  end
}

window["tenxsoydev/size-matters.nvim"] = {
  keys = {
    "<C-+>",
    "<C-S-+>",
    "<C-->",
    "<C-ScrollWheelUp>",
    "<C-ScrollWheelDown>",
    "<A-C-=>"
  }
}

return window
