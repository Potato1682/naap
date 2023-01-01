local M = {}

local severity = vim.diagnostic.severity
local ok, utf8 = pcall(require, "utf8")

if not ok then
  return {}
end

local char = utf8.char

function M.config()
  vim.diagnostic.config {
    float = {
      focusable = false,
      border = require("utils.border").get_border_char_and_hl(),
      scape = "cursor",
      header = { "Cursor Diagnostics:", "Special" },
      prefix = function(diagnostic, i, total)
        local icon, highlight

        if diagnostic.severity == severity.ERROR then
          icon = char(0xf659)
          highlight = "DiagnosticError"
        elseif diagnostic.severity == severity.WARN then
          icon = char(0xf529)
          highlight = "DiagnosticWarn"
        elseif diagnostic.severity == severity.INFO then
          icon = char(0xf7fc)
          highlight = "DiagnosticInfo"
        elseif diagnostic.severity == severity.HINT then
          icon = char(0xf835)
          highlight = "DiagnosticHint"
        end

        return i .. "/" .. total .. " " .. icon .. "  ", highlight
      end
    },
    severity_sort = true,
    virtual_text = false,
    underline = {
      severity = {
        min = vim.diagnostic.severity.INFO
      }
    },
    signs = true
  }

  local ns = vim.api.nvim_create_namespace("worst_diagnostics")
  local original_signs_handler = vim.diagnostic.handlers.signs

  vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, _, opts)
      local diagnostics = vim.diagnostic.get(bufnr)
      local max_severity_per_line = {}

      for _, diagnostic in pairs(diagnostics) do
        local max = max_severity_per_line[diagnostic.lnum]

        if not max or diagnostic.severity < max.severity then
          max_severity_per_line[diagnostic.lnum] = diagnostic
        end
      end

      local filtered_diagnostics = vim.tbl_values(max_severity_per_line)

      original_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,
    hide = function(_, bufnr)
      original_signs_handler.hide(ns, bufnr)
    end
  }
end

function M.define_signs()
  vim.fn.sign_define("DiagnosticSignError", {
    text = char(0xf659),
    texthl = "DiagnosticSignError"
  })

  vim.fn.sign_define("DiagnosticSignWarn", {
    text = char(0xf529),
    texthl = "DiagnosticSignWarn"
  })

  vim.fn.sign_define("DiagnosticSignInfo", {
    text = char(0xf7fc),
    texthl = "DiagnosticSignInfo"
  })

  vim.fn.sign_define("DiagnosticSignHint", {
    text = char(0xf835),
    texthl = "DiagnosticSignHint"
  })
end

function M.set_keymaps()
  local command = require("utils.command").command
  local keymap = require("utils.keymap").keymap

  command("DiagnosticsNext", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")
  command("DiagNext", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")

  command("DiagnosticsPrev", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")
  command("DiagPrev", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")

  keymap("n", "]a", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")
  keymap("n", "[a", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")

  keymap("n", "<leader>ld", "<cmd>TroubleToggle<cr>", {
    desc = "Workspace Diagnostics"
  })
end

M.config()
M.define_signs()
M.set_keymaps()

return M
