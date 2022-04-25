vim.g.loaded_tutor = 1
vim.g.loaded_spec = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_sql_completion = 1
vim.g.loaded_syntax_completion = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.vimsyn_embed = 1

vim.cmd("packadd vim-jetpack")

local jetpack = require("jetpack")

jetpack.startup(function(use)
  -- Self update
  use { "tani/vim-jetpack", opt = true }

  -- Core performance
  use { "lewis6991/impatient.nvim", opt = true }

  -- Colorscheme
  use { "olimorris/onedarkpro.nvim", as = "onedarkpro" }

  -- Icons
  use { "kyazdani42/nvim-web-devicons", as = "web-devicons" }
  use { "yamatsum/nvim-nonicons", as = "nonicons" }

  -- Bufferline
  use {
    "akinsho/bufferline.nvim",
    as = "bufferline",
    opt = vim.fn.exists("g:vscode") == 1
  }
  -- Notification
  use { "rcarriga/nvim-notify", as = "notify" }

  -- Editor

  -- Indent line
  use {
    "lukas-reineke/indent-blankline.nvim",
    opt = vim.fn.exists("g:vscode") == 1
  }

  -- MatchParen replace
  use {
    "andymass/vim-matchup",
    as = "matchup",

    event = "BufReadPost",
  }

  -- Cursor word highlight
  use {
    "RRethy/vim-illuminate",
    as = "illuminate",
  }

  -- Treesitter

  use {
    "nvim-treesitter/nvim-treesitter",
    as = "treesitter",

    opt = vim.fn.exists("g:vscode") == 1,

    run = ":TSUpdate",

    --[[ Treesitter Extensions
    requires = {
      {
        "p00f/nvim-ts-rainbow",
        as = "treesitter-rainbow",
      },
      {
        "windwp/nvim-ts-autotag",
        as = "treesitter-autotag",
      },
      {
        "rohit-px2/nvim-ts-highlightparams",
        as = "treesitter-highlightparams",

        config = function()
          require("nvim-ts-highlightparams").setup()
        end,
      },
      {
        "haringsrob/nvim_context_vt",
        as = "treesitter-context",
      },
      {
        "RRethy/nvim-treesitter-textsubjects",
        as = "treesitter-textsubjects",
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        as = "treesitter-textobjects",
      },
    },
    ]]
  }

  -- Treesitter extensions

  use {
    "p00f/nvim-ts-rainbow",
    as = "treesitter-rainbow",
    opt = vim.fn.exists("g:vscode") == 1
  }

  use {
    "windwp/nvim-ts-autotag",
    as = "treesitter-autotag",
    opt = vim.fn.exists("g:vscode") == 1
  }

  use {
    "haringsrob/nvim_context_vt",
    as = "treesitter-context",
    opt = vim.fn.exists("g:vscode") == 1
  }

  use {
    "RRethy/nvim-treesitter-textsubjects",
    as = "treesitter-textsubjects",
    opt = vim.fn.exists("g:vscode") == 1
  }

  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    as = "treesitter-textobjects",
    opt = vim.fn.exists("g:vscode") == 1
  }

  -- Profiling
  use { "dstein64/vim-startuptime", cmd = "StartupTime" }
end)

for _, name in ipairs(vim.fn["jetpack#names"]()) do
  if jetpack.tap(name) == 0 then
    jetpack.sync()

    break
  end
end

if vim.fn.exists("g:vscode") == 1 then
  require("configs.filetype")
end

if vim.fn.exists("g:vscode") == 1 then
  require("configs.bufferline")
end
if vim.fn.exists("g:vscode") == 1 then
  require("configs.indent-blankline")
end

if vim.fn.exists("g:vscode") == 1 then
  require("configs.treesitter")
end

