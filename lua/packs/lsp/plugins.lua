local lsp = {}

lsp["neovim/nvim-lspconfig"] = {
  opt = true
}

lsp["williamboman/nvim-lsp-installer"] = {
  opt = true
}

lsp["jose-elias-alvarez/null-ls.nvim"] = {
  after = "nvim-lspconfig"
}

lsp["rmagatti/goto-preview"] = {
  module = "goto-preview",

  setup = function()
    require("packs.lsp.config").goto_preview_setup()
  end,

  config = function()
    require("packs.lsp.config").goto_preview()
  end
}

lsp["Mofiqul/trld.nvim"] = {
  after = "nvim-lspconfig",

  config = function()
    require("packs.lsp.config").trld()
  end
}

lsp["j-hui/fidget.nvim"] = {
  module = "fidget"
}

lsp["lewis6991/hover.nvim"] = {
  module = "hover",

  setup = function()
    require("packs.lsp.config").hover_setup()
  end,

  config = function()
    require("packs.lsp.config").hover()
  end
}

lsp["shurizzle/inlay-hints.nvim"] = {
  module = "inlay-hints"
}

lsp["weilbith/nvim-code-action-menu"] = {
  cmd = "CodeActionMenu",

  config = function()
    vim.g.code_action_menu_window_border = "rounded"
  end
}

lsp["lukas-reineke/lsp-format.nvim"] = {
  after = "nvim-lspconfig"
}

return lsp
