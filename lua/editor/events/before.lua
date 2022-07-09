local api = vim.api

local group_yank = api.nvim_create_augroup("highlight_yank", {})

api.nvim_create_autocmd("TextYankPost", {
  group = group_yank,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 400
    }
  end,
  desc = "Highlight yanked text"
})

local group_terminal = api.nvim_create_augroup("terminal", {})

api.nvim_create_autocmd("TermOpen", {
  group = group_terminal,
  pattern = "term://*",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.signcolumn = "no"
  end,
  desc = "Disable some annoying artifacts in terminal"
})

