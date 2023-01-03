local lsp = {}

lsp["williamboman/mason.nvim"] = {
  requires = {
    { "neovim/nvim-lspconfig", module = "lspconfig" },
    { "williamboman/mason-lspconfig.nvim", module = "mason-lspconfig" },
    { "jay-babu/mason-null-ls.nvim", module = "mason-null-ls" },
  },

  wants = {
    "nvim-lspconfig",
    "mason-lspconfig.nvim",
    "mason-null-ls.nvim",
  },

  event = {
    "BufNewFile",
    "BufReadPre",
  },

  cmd = {
    "Mason",
    "MasonLog",
  },

  setup = function()
    require("packs.lsp.config").mason_setup()
  end,

  config = function()
    require("packs.lsp.config").mason()
  end,
}

lsp["jose-elias-alvarez/null-ls.nvim"] = {
  cmd = "NullLsInfo",

  module = "null-ls",
}

lsp["kosayoda/nvim-lightbulb"] = {
  module = "nvim-lightbulb",

  setup = function()
    require("packs.lsp.config").lightbulb_setup()
  end,

  config = function()
    require("packs.lsp.config").lightbulb()
  end,
}

lsp["dnlhc/glance.nvim"] = {
  cmd = "Glance",

  config = function()
    require("packs.lsp.config").glance()
  end,
}

lsp["lvimuser/lsp-inlayhints.nvim"] = {
  module = "lsp-inlayhints",

  config = function()
    require("packs.lsp.config").inlay_hints()
  end,
}

lsp["weilbith/nvim-code-action-menu"] = {
  cmd = "CodeActionMenu",

  config = function()
    vim.g.code_action_menu_window_border = "rounded"
  end,
}

lsp["smjonas/inc-rename.nvim"] = {
  cmd = "IncRename",

  config = function()
    require("packs.lsp.config").inc_rename()
  end,
}

lsp["utilyre/barbecue.nvim"] = {
  requires = {
    { "nvim-tree/nvim-web-devicons", opt = true },
    { "SmiteshP/nvim-navic", module = "nvim-navic" },
  },

  wants = {
    "nvim-web-devicons",
  },

  event = "BufRead",

  config = function()
    require("packs.lsp.config").barbecue()
  end,
}

lsp["lukas-reineke/lsp-format.nvim"] = {
  module = "lsp-format",
}

return lsp
