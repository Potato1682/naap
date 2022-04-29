local M = {}

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
    }
  }

  colorscheme.load()
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

  -- TODO
  --[[
  vim.keymap.set("n", "<Tab>", function()
    bufferline.cycle_next()
  end)
  ]]

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
      custom_filter = function(bufnr)
        if vim.bo[bufnr].buftype == "terminal" then
          return false
        end

        return true
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = function()
            return "Explorer" .. " - " .. vim.loop.cwd()
          end,
          highlight = "Function",
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

  vim.keymap.set("n", "<Tab>", function()
    require("bufferline").cycle(1)
  end)

  vim.keymap.set("n", "<S-Tab>", function()
    require("bufferline").cycle(-1)
  end)

  vim.keymap.set("n", "gb", function()
    require("bufferline").pick_buffer()
  end)
end

return M

