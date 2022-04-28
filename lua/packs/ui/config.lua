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

return M

