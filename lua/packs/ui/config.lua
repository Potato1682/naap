local M = {}

function M.lumen_cond()
  return require("packs.helper").in_vscode()
end

function M.lumen_setup()
  vim.g.lumen_startup_overwrite = 1
end

function M.colorscheme()
  local colorscheme = require("onedarkpro")

  colorscheme.setup {
    plugins = {
      native_lsp = true,
      polyglot = false,
      treesitter = true
    },
    styles = {
      comments = "italic"
    },
    options = {
      bold = false,
      italic = true,
      undercurl = true,
      cursorline = O.editor.cursor_highlight.line
    },
    hlgroups = {
      DiagnosticUnderlineError = {
        fg = "NONE"
      },
      DiagnosticUnderlineWarn = {
        fg = "NONE"
      },
      DiagnosticUnderlineInfo = {
        fg = "NONE"
      },
      DiagnosticUnderlineHint = {
        fg = "NONE"
      }
    }
  }

  colorscheme.load()
end

function M.dressing()
  require("dressing").setup {
    input = {
      enabled = true,

      border = "rounded"
    },
    select = {
      enabled = true,

      backend = "nui",

      nui = {
        border = {
          style = "rounded"
        }
      }
    }
  }
end

function M.notify()
  require("notify").setup {
    background_colour = function()
      local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#")

      if group_bg == "" or group_bg == "none" then
        group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Float")), "bg#")

        if group_bg == "" or group_bg == "none" then
          return "#000000"
        end
      end

      return group_bg
    end
  }
end

function M.bufferline()
  local bufferline = require("bufferline")
  local groups = require("bufferline.groups")
  local char = require("utf8").char

  bufferline.setup {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = true,
      diagnostics_indicator = function(count, level)
        if level:match("error") then
          return char(0xf658) .. " " .. count
        elseif level:match("warning") then
          return char(0xf525) .. " " .. count
        end

        return ""
      end,
      close_command = function(bufnr)
        require("bufdelete").bufdelete(bufnr, true)
      end,
      right_mouse_command = "vertical sbuffer %d",
      custom_filter = function(bufnr)
        if vim.bo[bufnr].buftype == "terminal" then
          return false
        end

        return true
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo Tree",
          highlight = "Keyword",
          text_align = "center"
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff",
          highlight = "Function",
          text_align = "center"
        },
        {
          filetype = "dbui",
          text = "DBUI",
          highlight = "Keyword",
          text_align = "center"
        }
      },
      show_close_icon = false,
      groups = {
        options = {
          toggle_hidden_on_enter = true
        },
        items = {
          {
            name = "tests",
            priority = 2,
            icon = char(0xfb8e) .. " ",
            matcher = function(buf)
              return buf.filename:match("%_test") or buf.filename:match("%_spec")
            end
          },
          groups.builtin.ungrouped,
          {
            name = "docs",
            icon = char(0xf831) .. " ",
            matcher = function(buf)
              return buf.filename:match "%.md" or buf.filename:match "%.txt" or buf.filename:match "%.rst"
            end
          }
        }
      }
    }
  }

  vim.keymap.set("n", "gb", function()
    require("bufferline").pick_buffer()
  end, {
    desc = "Pick Buffer"
  })
end

function M.indent_blankline()
  require("indent_blankline").setup {
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = { "man", "help", "python" },
    disable_with_nolist = false,
    space_char_blankline = " ",

    use_treesitter = true,
    show_current_context = true,

    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type"
    }
  }

  vim.cmd("hi! IndentBlanklineContextChar guifg=#3d8cf0 guibg=NONE gui=nocombine")
end

return M
