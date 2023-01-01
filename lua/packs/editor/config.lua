local M = {}

function M.smartpairs()
  require("pairs"):setup {
    enter = {
      enable_mapping = false
    },
    autojump_strategy = {
      unbalanced = "all"
    },
    enable_smart_space = true
  }
end

function M.hlslens_setup()
  local keymap = require("utils.keymap.presets").mode_only("n", { silent = true })

  keymap(
    "n",
    function()
      require("cinnamon.scroll").scroll(vim.v.count1 .. "n", 1, 0, 3)
      vim.api.nvim_feedkeys("zzzv", "n", true)

      require("hlslens").start()
    end,
    "Next search hit"
  )
  keymap(
    "N",
    function()
      require("cinnamon.scroll").scroll(vim.v.count1 .. "N", 1, 0, 3)
      vim.api.nvim_feedkeys("zzzv", "n", true)

      require("hlslens").start()
    end,
    "Previous search hit"
  )

  keymap("*", [[*<cmd>lua require("hlslens").start()<cr>]], "Search")
  keymap("#", [[#<cmd>lua require("hlslens").start()<cr>]], "Search")
  keymap("g*", [[g*<cmd>lua require("hlslens").start()<cr>]], "Search")
  keymap("g#", [[g#<cmd>lua require("hlslens").start()<cr>]], "Search")

  keymap("<leader>h", function()
    vim.cmd("nohlsearch")

    local hlslens = require("hlslens")

    hlslens.disable()
    hlslens.enable()
  end, "nohlsearch")
end

function M.accelerated_jk()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("j", "<Plug>(accelerated_jk_gj)", "Down")
  keymap("k", "<Plug>(accelerated_jk_gk)", "Up")
end

function M.cinnamon()
  require("cinnamon").setup {
    extra_keymaps = true,
    scroll_limit = 100
  }
end

function M.houdini()
  require("houdini").setup {
    mappings = {
      "jk",
      "AA",
      "II"
    },
    escape_sequences = {
      i = function(first, second)
        local seq = first .. second

        if seq == "AA" then
          return "<BS><BS><End>"
        end

        if seq == "II" then
          return "<BS><BS><Home>"
        end

        return "<BS><BS><ESC>"
      end
    }
  }
end

function M.fF_highlight()
  require("fFHighlight").setup()
end

function M.marks()
  require("marks").setup {
    force_write_shada = true
  }
end

function M.colorizer()
  require("colorizer").setup()
end

function M.comment()
  require("Comment").setup {
    pre_hook = function(context)
      local utils = require("Comment.utils")

      local type = context.ctype == utils.ctype.line and "__default" or "__multiline"

      local location = nil

      if context.ctype == utils.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif context.cmotion == utils.cmotion.v or context.cmotion == utils.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
        key = type,
        location = location
      }
    end
  }
end

function M.abbreinder()
  require("abbreinder").setup()
end

function M.hclipboard()
  require("hclipboard").start()
end

function M.trouble()
  require("trouble").setup {
    auto_close = true
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "Trouble",
    callback = function()
      vim.opt_local.colorcolumn = ""
    end
  })
end

function M.todo_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>t", function()
    vim.cmd("TodoTelescope")
  end, "Todos")
end

function M.todo()
  require("todo-comments").setup()

  require("utils.telescope").register_extension("todo-comments")
end

function M.pqf()
  local char = require("utf8").char

  require("pqf").setup {
    signs = {
      error = char(0xf659),
      warn = char(0xf529),
      info = char(0xf7fc),
      hint = char(0xf835)
    }
  }
end

function M.dial_setup()
  local keymap_n = require("utils.keymap").omit("insert", "n", "<C-^%>", { noremap = true, expr = true })
  local keymap_v = require("utils.keymap.presets").mode_only("v", { noremap = true, expr = true })

  keymap_n("a", function()
    return require("dial.map").inc_normal()
  end, "Increment")
  keymap_n("x", function()
    return require("dial.map").dec_normal()
  end, "Decrement")

  keymap_v("<C-a>", function()
    return require("dial.map").inc_visual()
  end, "Increment")
  keymap_v("<C-x>", function()
    return require("dial.map").dec_visual()
  end, "Decrement")
  keymap_v("g<C-a>", function()
    return require("dial.map").inc_gvisual()
  end, "Increment")
  keymap_v("g<C-x>", function()
    return require("dial.map").dec_gvisual()
  end, "Decrement")
end

function M.dial()
  local augend = require("dial.augend")

  require("dial.config").augends:register_group {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.semver.alias.semver,
      augend.constant.alias.bool,
      augend.constant.new {
        elements = {
          "yes",
          "no"
        },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = {
          "Yes",
          "No"
        },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = {
          "YES",
          "NO"
        },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = {
          "let",
          "const"
        },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = {
          "and",
          "or"
        },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = {
          "&&",
          "||"
        },
        word = false,
        cyclic = true
      },
      augend.case.new {
        types = {
          "camelCase",
          "snake_case"
        }
      },
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%Y年%-m月%-d日"],
      augend.date.alias["%Y年%-m月%-d日(%ja)"],
      augend.constant.alias.ja_weekday,
      augend.constant.alias.ja_weekday_full,
      augend.paren.alias.quote,
      augend.paren.alias.brackets,
      augend.paren.lua_str_literal,
      augend.paren.rust_str_literal,
      augend.misc.markdown_header
    }
  }
end

function M.stay_in_place_setup()
  local keymap = require("utils.keymap").omit("append", "n", "", { noremap = true })
  local keymap_visual = require("utils.keymap").omit("append", "v", "", { noremap = true })
  local keymap_expr = require("utils.keymap").omit("append", "n", "", { noremap = true, expr = true })

  keymap_expr("<", function()
    require("stay-in-place").shift_left()
  end, "Shift Left")

  keymap_expr(">", function()
    require("stay-in-place").shift_right()
  end, "Shift Right")

  keymap_expr("=", function()
    require("stay-in-place").filter()
  end, "Filter")

  keymap("<<", function()
    require("stay-in-place").shift_left_line()
  end, "Shift Left (Line wise)")

  keymap(">>", function()
    require("stay-in-place").shift_right_line()
  end, "Shift Right (Line wise)")

  keymap("==", function()
    require("stay-in-place").filter_line()
  end, "Filter (Line wise)")

  keymap_visual("<", function()
    require("stay-in-place").shift_left_visual()
  end, "Shift Left")

  keymap_visual(">", function()
    require("stay-in-place").shift_right_visual()
  end, "Shift Right")

  keymap_visual("=", function()
    require("stay-in-place").filter_visual()
  end, "Filter")
end

function M.stay_in_place()
  require("stay-in-place").setup {
    set_keymaps = false
  }
end

return M
