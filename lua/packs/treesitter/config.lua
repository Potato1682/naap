local M = {}

function M.treesitter()
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    highlight = { enable = true },
    yati = { enable = true },
    rainbow = {
      enable = true,
      disable = {
        "html",
        "svelte",
        "vue"
      }
    },
    context_commentstring = {
      enable = true
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-big"
      },
    },
  }

  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

function M.autotag()
  require("nvim-ts-autotag").setup()
end

function M.hlargs()
  vim.api.nvim_create_autocmd("Colorscheme", {
    pattern = "*",
    callback = function()
      vim.cmd("highlight! link HlArgs TSParameter")
    end
  })

  require("hlargs").setup()
end

function M.spellsitter()
  require("spellsitter").setup()
end

function M.gps()
  local char = require("utf8").char

  require("nvim-gps").setup {
    icons = {
      ["class-name"] = char(0xf6a5) .. " ",
      ["function-name"] = char(0xf6a6) .. " ",
      ["method-name"] = char(0xf6a7) .. " ",
      ["container-name"] = char(0xf636) .. " ",
      ["tag-name"] = char(0xf673) .. " "
    },

    separator = string.format(" %s ", char(0xf641)),

    depth = 3,

    depth_limit_indicator = ".."
  }
end

function M.context()
  require("treesitter-context").setup {
    enable = true,
    throttle = true
  }
end

function M.trevj_setup()
  vim.keymap.set("n", "<localleader>j", function()
    require("trevj").format_at_cursor()
  end)
  -- TODO
  --[[
  vim.keymap.set("n", "<localleader>j", function()
    require("trevj").format_at_cursor()
  end)
  ]]
end

function M.trevj()
  require("trevj").setup {
    final_separator = O.lang.insert_comma_after_obj
  }
end

function M.unit_setup()
  vim.keymap.set("x", "iu", function()
    require("treesitter-unit").select()
  end)
  vim.keymap.set("x", "au", function()
    require("treesitter-unit").select(true)
  end)
  vim.keymap.set("o", "iu", function()
    require("treesitter-unit").select()
  end)
  vim.keymap.set("o", "au", function()
    require("treesitter-unit").select(true)
  end)
end

function M.refactoring()
  require("refactoring").setup {}
end

return M

