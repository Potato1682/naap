local git = {}
local conf = require("packs.git.config")

git["lewis6991/gitsigns.nvim"] = {
  opt = true,

  run = function()
    vim.cmd("packadd gitsigns.nvim")

    require("packs.git.config").gitsigns()
  end,

  config = function()
    require("packs.git.config").gitsigns()
  end
}

return git
