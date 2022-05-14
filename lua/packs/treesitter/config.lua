local M = {}

function M.treesitter()
  local options = {
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
    endwise = {
      enable = true
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-big"
      },
    },
  }

  --[[
  local lines = vim.api.nvim_buf_line_count(0)

  if lines > 30000 then
    options.highlight = false
    options.yati = false
    options.rainbow = false
    options.textsubjects = false
  ]]

  require("nvim-treesitter.configs").setup(options)

  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
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

function M.surf_setup()
  vim.keymap.set("n", "<A-j>", function()
    require("syntax-tree-surfer").move("n", false)
  end, {
    silent = true
  })

  vim.keymap.set("n", "<A-k>", function()
    require("syntax-tree-surfer").move("n", true)
  end, {
    silent = true
  })

  vim.keymap.set("n", "vx", function()
    require("syntax-tree-surfer").select()
  end, {
    silent = true
  })

  vim.keymap.set("n", "vn", function()
    require("syntax-tree-surfer").select_current_node()
  end, {
    silent = true
  })

  vim.keymap.set("x", "<A-j>", function()
    require("syntax-tree-surfer").surf("next", "visual", true)
  end, {
    silent = true
  })

  vim.keymap.set("x", "<A-k>", function()
    require("syntax-tree-surfer").surf("prev", "visual", true)
  end, {
    silent = true
  })

  vim.keymap.set("x", "H", function()
    require("syntax-tree-surfer").surf("parent", "visual")
  end, {
    silent = true
  })

  vim.keymap.set("x", "J", function()
    require("syntax-tree-surfer").surf("next", "visual")
  end, {
    silent = true
  })

  vim.keymap.set("x", "K", function()
    require("syntax-tree-surfer").surf("prev", "visual")
  end, {
    silent = true
  })

  vim.keymap.set("x", "L", function()
    require("syntax-tree-surfer").surf("child", "visual")
  end, {
    silent = true
  })
end

return M

