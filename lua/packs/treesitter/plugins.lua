local treesitter = {}
local conf = require("packs.treesitter.config")

treesitter["nvim-treesitter/nvim-treesitter"] = {
  opt = true,

  run = function()
    vim.cmd("packadd nvim-treesitter")

    require("packs.treesitter.config").treesitter()
  end,

  config = function()
    require("packs.treesitter.config").treesitter()
  end
}

treesitter["yioneko/nvim-yati"] = {
  after = "nvim-treesitter"
}

treesitter["p00f/nvim-ts-rainbow"] = {
  after = "nvim-treesitter"
}

treesitter["windwp/nvim-ts-autotag"] = {
  after = "nvim-treesitter",

  config = function()
    require("packs.treesitter.config").autotag()
  end
}
treesitter["RRethy/nvim-treesitter-endwise"] = {
  after = "nvim-treesitter"
}

treesitter["JoosepAlviste/nvim-ts-context-commentstring"] = {
  after = "nvim-treesitter"
}

treesitter["m-demare/hlargs.nvim"] = {
  after = "nvim-treesitter",

  config = function()
    require("packs.treesitter.config").hlargs()
  end
}

treesitter["lewis6991/spellsitter.nvim"] = {
  after = "nvim-treesitter",

  config = function()
    require("packs.treesitter.config").spellsitter()
  end
}

treesitter["SmiteshP/nvim-gps"] = {
  after = "nvim-treesitter",

  disable = vim.fn.has("nvim-0.8") == 1,

  config = function()
    require("packs.treesitter.config").gps()
  end
}

treesitter["lewis6991/nvim-treesitter-context"] = {
  after = "nvim-treesitter",

  disable = vim.fn.has("nvim-0.8") == 1,

  config = function()
    require("packs.treesitter.config").context()
  end
}

treesitter["AckslD/nvim-trevJ.lua"] = {
  module = "trevj",

  setup = function()
    require("packs.treesitter.config").trevj_setup()
  end,
  config = function()
    require("packs.treesitter.config").trevj()
  end
}

treesitter["ziontee113/syntax-tree-surfer"] = {
  module = "syntax-tree-surfer",

  setup = function()
    require("packs.treesitter.config").surf_setup()
  end
}

treesitter["RRethy/nvim-treesitter-textsubjects"] = {
  after = "nvim-treesitter"
}

return treesitter

