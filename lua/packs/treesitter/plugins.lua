local treesitter = {}

treesitter["nvim-treesitter/nvim-treesitter"] = {
  event = { "BufNew", "BufRead" },

  module = "nvim-treesitter",

  run = function()
    local ts_update = require("nvim-treesitter.install").update({ with_sync = true })

    ts_update()
  end,

  config = function()
    vim.schedule(function()
      if vim.opt_local.buftype:get() ~= "" then
        return
      end

      local ok, stat = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))

      if not ok then
        return
      end

      if not stat then
        return
      end

      if stat.type ~= "file" then
        return
      end

      local ok, parser = pcall(vim.treesitter.get_parser, 0)

      if not ok then
        return
      end

      if not parser then
        return
      end

      vim.cmd.e({ bang = true }) -- FIXME Temporal workaround to enable highlight. It is NOT good...
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
