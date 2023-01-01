local completion = {}

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

completion["hrsh7th/nvim-cmp"] = {
  requires = {
    -- General
    {
      "tzachar/cmp-fuzzy-buffer",

      requires = {
        { "tzachar/fuzzy.nvim", opt = true },
      },

      wants = {
        "fuzzy.nvim",
      },

      module = "cmp_fuzzy_buffer",
      event = { "InsertEnter", "CmdlineEnter" },
    },
    {
      "tzachar/cmp-fuzzy-path",

      requires = {
        { "tzachar/fuzzy.nvim", opt = true },
      },

      wants = {
        "fuzzy.nvim",
      },

      event = { "InsertEnter", "CmdlineEnter" },
    },
    { "hrsh7th/cmp-path", event = { "InsertEnter", "CmdlineEnter" } },

    -- LSP
    { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", event = { "InsertEnter", "CmdlineEnter" } },
    { "onsails/lspkind.nvim", event = { "InsertEnter", "CmdlineEnter" } },

    -- Snippets
    { "saadparwaiz1/cmp_luasnip", event = { "InsertEnter", "CmdlineEnter" } },

    -- Cmdline
    { "hrsh7th/cmp-cmdline", event = { "InsertEnter", "CmdlineEnter" } },
    { "dmitmel/cmp-cmdline-history", event = { "InsertEnter", "CmdlineEnter" } },

    -- Git
    {
      "petertriho/cmp-git",

      event = { "InsertEnter", "CmdlineEnter" },

      config = function()
        require("packs.completion.config").cmp_git()
      end,
    },

    -- DAP
    { "rcarriga/cmp-dap", event = { "InsertEnter", "CmdlineEnter" } },

    -- Copilot
    {
      "zbirenbaum/copilot-cmp",

      requires = {
        {
          "zbirenbaum/copilot.lua",

          opt = true,

          config = function()
            require("packs.completion.config").copilot()
          end,
        },
      },

      wants = {
        "copilot.lua",
      },

      module = "copilot_cmp",
    },

    -- Database
    {
      "kristijanhusak/vim-dadbod-completion",

      event = { "InsertEnter", "CmdlineEnter" },

      config = function()
        require("packs.completion.config").dadbod()
      end,
    },

    --[[
      These plugins are loaded at start / module requiring to prevent any errors
      They have no after/**/*.lua, we have to load **before** cmp is loaded (or on-demand)
    ]]

    -- Sorting
    { "lukas-reineke/cmp-under-comparator", module = "cmp-under-comparator" },

    -- Tabnine
    {
      "tzachar/cmp-tabnine",

      event = { "InsertEnter", "CmdlineEnter" },

      run = tabnine_run,

      config = function()
        require("packs.completion.config").tabnine()
      end,
    },
  },

  module = "cmp",

  config = function()
    require("packs.completion.config").cmp()
  end,
}

return completion
