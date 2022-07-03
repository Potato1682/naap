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
  local keymap = require("utils.keymap").keymap

  keymap("n", "<localleader>j", function()
    require("trevj").format_at_cursor()
  end, "Join Lines")
end

function M.trevj()
  require("trevj").setup {
    final_separator = O.lang.insert_comma_after_obj
  }
end

function M.refactoring()
  require("refactoring").setup {}
end

function M.surf_setup()
  local keymap = require("utils.keymap.presets").mode_only("n", { silent = true })
  local keymap_visual = require("utils.keymap.presets").mode_only("x", { silent = true })

  keymap("<A-j>", function()
    require("syntax-tree-surfer").move("n", false)
  end, "Move Current Node Down")

  keymap("<A-k>", function()
    require("syntax-tree-surfer").move("n", true)
  end, "Move Current Node Up")

  keymap("vx", function()
    require("syntax-tree-surfer").select()
  end, "Select Current Node")

  keymap("vn", function()
    require("syntax-tree-surfer").select_current_node()
  end, "Select Current Node")

  keymap("p", function()
    require("syntax-tree-surfer").go_to_top_node_and_execute_commands(false, {
      "normal! O",
      "normal! O",
      "startinsert"
    })
  end, "Let's brain power'")

  keymap_visual("<A-j>", function()
    require("syntax-tree-surfer").surf("next", "visual", true)
  end, "Surf Down")

  keymap_visual("<A-k>", function()
    require("syntax-tree-surfer").surf("prev", "visual", true)
  end, "Surf Up")

  keymap_visual("H", function()
    require("syntax-tree-surfer").surf("parent", "visual")
  end, "Select Parent Node")

  keymap_visual("J", function()
    require("syntax-tree-surfer").surf("next", "visual")
  end, "Select Next Node")

  keymap_visual("K", function()
    require("syntax-tree-surfer").surf("prev", "visual")
  end, "Select Previous Node")

  keymap_visual("L", function()
    require("syntax-tree-surfer").surf("child", "visual")
  end, "Select Child Node")
end

return M
