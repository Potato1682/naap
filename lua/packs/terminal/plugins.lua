local terminal = {}

terminal["akinsho/toggleterm.nvim"] = {
  -- module = "toggleterm",
  --
  -- cmd = {
  --   "ToggleTerm",
  --   "TermExec"
  -- },

  config = function()
    require("packs.terminal.config").toggleterm()
  end
}

return terminal
