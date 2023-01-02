local M = {}

function M.colorscheme()
  local colorscheme = require("catppuccin")

  colorscheme.setup({
    flavour = "macchiato",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = O.appearance.transparency,
    custom_highlights = function(_)
      return {
        Search = {
          fg = "NONE",
        },
        IncSearch = {
          fg = "NONE",
        },
        DiagnosticUnderlineError = {
          fg = "NONE",
        },
        DiagnosticUnderlineWarn = {
          fg = "NONE",
        },
        DiagnosticUnderlineInfo = {
          fg = "NONE",
        },
        DiagnosticUnderlineHint = {
          fg = "NONE",
        },
      }
    end,
    integrations = {
      gitsigns = true,
      lsp_saga = true,
      markdown = true,
      mason = true,
      neotree = true,
      neotest = true, -- TODO
      noice = true,
      cmp = true,
      dap = {
        enabled = true,
        enable_ui = true,
      },
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          hints = { "undercurl" },
        },
      },
      navic = {
        enabled = true,
        custom_bg = "NONE",
      },
      notify = true,
      treesitter_context = true,
      treesitter = true,
      ts_rainbow = true,
      telescope = true,
      illuminate = true,
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
    },
  })

  colorscheme.load()

  require("utils.colors").setup()
end

function M.dressing()
  require("dressing").setup({
    input = {
      enabled = true,

      border = "rounded",
    },
    select = {
      enabled = true,

      backend = "nui",

      nui = {
        border = {
          style = "rounded",
        },
      },
    },
  })
end

function M.notify()
  require("notify").setup({
    background_colour = function()
      local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#")

      if group_bg == "" or group_bg == "none" then
        group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Float")), "bg#")

        if group_bg == "" or group_bg == "none" then
          return "#000000"
        end
      end

      return group_bg
    end,
  })

  require("utils.telescope").register_extension("notify")
end

function M.noice_setup()
  if not _G.__vim_notify_overwritten then
    vim.notify = function(...)
      local args = { ... }

      local ok = pcall(require, "notify")

      if not ok then
        vim.cmd.packadd("nvim-notify")

        require("notify")
      end

      local ok = pcall(require, "noice")

      if not ok then
        vim.cmd.packadd("noice.nvim")

        require("noice")
      end

      vim.schedule(function()
        if args ~= nil then
          vim.notify(unpack(args))
        end
      end)
    end

    _G.__vim_notify_overwritten = true
  end
end

function M.noice()
  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
  })
end

function M.bufferline()
  local bufferline = require("bufferline")
  local groups = require("bufferline.groups")
  local char = require("utf8").char

  vim.cmd([[
    function! Toggle_light_dark(a, b, c, d)
      lua require("utils.colors").toggle_light_dark()
    endfunction
  ]])

  bufferline.setup({
    options = {
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
      }),
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
          text_align = "center",
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff",
          highlight = "Function",
          text_align = "center",
        },
        {
          filetype = "dbui",
          text = "DBUI",
          highlight = "Keyword",
          text_align = "center",
        },
      },
      show_close_icon = false,
      custom_areas = {
        right = function()
          local result = {}

          table.insert(result, {
            text = "%@Toggle_light_dark@ " .. vim.g.symbol_icon .. " %X",
            guifg = vim.g.symbol_icon_fg,
          })

          table.insert(result, {
            text = "%@Toggle_light_dark@" .. vim.g.toggle_icon .. " %X ",
            guifg = vim.g.toggle_icon_fg,
          })

          return result
        end,
      },
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          {
            name = "tests",
            priority = 2,
            icon = char(0xfb8e) .. " ",
            matcher = function(buf)
              return buf.filename:match("%_test") or buf.filename:match("%_spec")
            end,
          },
          groups.builtin.ungrouped,
          {
            name = "docs",
            icon = char(0xf831) .. " ",
            matcher = function(buf)
              return vim.tbl_contains({
                "md",
                "mdx",
                "rst",
                "txt",
                "wiki",
              }, vim.fn.fnamemodify(buf.path, ":e"))
            end,
          },
        },
      },
    },
  })

  local keymap = require("utils.keymap").keymap

  keymap("n", "gb", function()
    require("bufferline").pick_buffer()
  end, "Pick Buffer")
end

function M.indent_blankline()
  require("indent_blankline").setup({
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = { "man", "help", "python" },
    disable_with_nolist = false,
    space_char_blankline = " ",

    char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
      "IndentBlanklineIndent6",
    },

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
      "operation_type",
    },
  })
end

return M
