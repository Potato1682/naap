local completion = {}

completion["hrsh7th/nvim-cmp"] = {
  opt = true
}

-- General
completion["tzachar/cmp-fuzzy-buffer"] = {
  requires = { {
    "romgrk/fzy-lua-native",

    module = "fzy-lua-native",

    run = "make"
  }, {
    "tzachar/fuzzy.nvim",

    module = "fuzzy_nvim"
  } },

  after = "nvim-cmp"
}
completion["tzachar/cmp-fuzzy-path"] = {
  opt = true
}
completion["hrsh7th/cmp-path"] = {
  opt = true
}

-- Sorting
completion["lukas-reineke/cmp-under-comparator"] = {
  after = "nvim-cmp"
}

-- LSP
completion["hrsh7th/cmp-nvim-lsp"] = {
  module = "cmp_nvim_lsp"
}
completion["hrsh7th/cmp-nvim-lsp-document-symbol"] = {
  after = "nvim-cmp"
}
completion["onsails/lspkind.nvim"] = {
  after = "nvim-cmp"
}

-- Snippets
completion["saadparwaiz1/cmp_luasnip"] = {
  after = "nvim-cmp"
}

-- Tabnine
local is_windows = require("core.constants").is_windows
local tabnine_run

if is_windows then
  if vim.fn.executable("pwsh") == 1 then
    tabnine_run = "pwsh ./install.ps1"
  else
    tabnine_run = "powershell ./install.ps1"
  end
else
  tabnine_run = "./install.sh"
end

completion["tzachar/cmp-tabnine"] = {
  after = "nvim-cmp",

  run = tabnine_run,

  config = function()
    require("packs.completion.config").tabnine()
  end
}

-- Cmdline
completion["hrsh7th/cmp-cmdline"] = {
  after = "nvim-cmp"
}
completion["dmitmel/cmp-cmdline-history"] = {
  after = "nvim-cmp"
}

-- Git
completion["petertriho/cmp-git"] = {
  after = "nvim-cmp",

  config = function()
    require("packs.completion.config").cmp_git()
  end
}

-- DAP
completion["rcarriga/cmp-dap"] = {
  after = "nvim-cmp"
}

-- Copilot
completion["github/copilot.vim"] = {
  cmd = "Copilot"
}

completion["zbirenbaum/copilot.lua"] = {
  event = "InsertEnter",

  config = function()
    require("packs.completion.config").copilot()
  end
}

completion["zbirenbaum/copilot-cmp"] = {
  after = "nvim-cmp"
}

completion["kristijanhusak/vim-dadbod-completion"] = {
  after = "nvim-cmp",

  config = function()
    require("packs.completion.config").dadbod()
  end
}

return completion
