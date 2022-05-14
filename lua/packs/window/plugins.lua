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

return window
