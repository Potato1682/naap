local core = {}

core["lewis6991/impatient.nvim"] = {}

-- plenary
core["nvim-lua/plenary.nvim"] = {}

-- lua 5.3
core["uga-rosa/utf8.nvim"] = {}

core["kevinhwang91/promise-async"] = {}

core["antoinemadec/FixCursorHold.nvim"] = {
  event = "BufEnter",

  config = function()
    vim.g.cursorhold_updatetime = 100
  end
}

return core

