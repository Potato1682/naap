local M = {}

local char = require("utf8").char

function M.config()
  vim.diagnostic.config {
    virtual_text = false,
    underline = {
      severity = {
        min = vim.diagnostic.severity.INFO
      }
    },
    signs = true
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
