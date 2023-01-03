local treesitter = {}

treesitter["nvim-treesitter/nvim-treesitter"] = {
  event = { "BufNew", "BufRead", "BufFilePost" },

  module = "nvim-treesitter",

  run = function()
    local ts_update = require("nvim-treesitter.install").update({ with_sync = true })

    ts_update()
  end,

  config = function()
    vim.schedule(function()
      vim.cmd("e!") -- FIXME Temporal workaround to enable highlight. It is NOT good...
    end)

    require("packs.treesitter.config").treesitter()
  end,
}

treesitter["https://git.sr.ht/~p00f/nvim-ts-rainbow"] = {
  after = "nvim-treesitter",
}

treesitter["yioneko/nvim-yati"] = {
  after = "nvim-treesitter",
}

treesitter["windwp/nvim-ts-autotag"] = {
  after = "nvim-treesitter",
}

treesitter["RRethy/nvim-treesitter-endwise"] = {
  after = "nvim-treesitter",
}

treesitter["JoosepAlviste/nvim-ts-context-commentstring"] = {
  after = "nvim-treesitter",
}

treesitter["RRethy/nvim-treesitter-textsubjects"] = {
  after = "nvim-treesitter",
}

treesitter["m-demare/hlargs.nvim"] = {
  after = "nvim-treesitter",

  config = function()
    require("packs.treesitter.config").hlargs()
  end,
}

treesitter["Wansmer/treesj"] = {
  module = "treesj",

  setup = function()
    require("packs.treesitter.config").treesj_setup()
  end,

  config = function()
    require("packs.treesitter.config").treesj()
  end,
}

treesitter["ziontee113/syntax-tree-surfer"] = {
  module = "syntax-tree-surfer",

  setup = function()
    require("packs.treesitter.config").surf_setup()
  end,
}

return treesitter
