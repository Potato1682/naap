local treesitter = {}
local conf = require("packs.treesitter.config")

treesitter["nvim-treesitter/nvim-treesitter"] = {
  run = ":TSUpdate",

  config = conf.treesitter
}

treesitter["yioneko/nvim-yati"] = {}

treesitter["p00f/nvim-ts-rainbow"] = {}

treesitter["windwp/nvim-ts-autotag"] = {
  config = conf.autotag
}

treesitter["JoosepAlviste/nvim-ts-context-commentstring"] = {}

treesitter["m-demare/hlargs.nvim"] = {
  config = conf.hlargs
}

treesitter["lewis6991/spellsitter.nvim"] = {
  config = conf.spellsitter
}

treesitter["SmiteshP/nvim-gps"] = {
  config = conf.gps
}

treesitter["lewis6991/nvim-treesitter-context"] = {
  config = conf.context
}

treesitter["AckslD/nvim-trevJ.lua"] = {
  module = "trevj",

  setup = conf.trevj_setup,
  config = conf.trevj
}

treesitter["David-Kunz/treesitter-unit"] = {
  module = "treesitter-unit",

  setup = conf.unit_setup
}

treesitter["RRethy/nvim-treesitter-textsubjects"] = {}

return treesitter

