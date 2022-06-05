local terminal = {}

terminal["akinsho/toggleterm.nvim"] = {
  -- module = "toggleterm",
  --
  -- cmd = {
  --   "ToggleTerm",
  --   "TermExec"
  -- },
  --
  setup = function()
    require("packs.terminal.config").toggleterm_setup()
  end,

  config = function()
    require("packs.terminal.config").toggleterm()
  end
}

return terminal
