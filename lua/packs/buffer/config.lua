local M = {}

function M.bufdelete_setup()
  vim.keymap.set("n", "<leader>q", function()
    require("bufdelete").bufdelete(0, false)
  end, {
    desc = "Close Buffer"
  })
end

function M.cybu_setup()
  vim.keymap.set("n", "<Tab>", function()
    require("cybu").cycle("next")
  end, {
    silent = true,
    desc = "Next buffer"
  })
  vim.keymap.set("n", "<S-Tab>", function()
    require("cybu").cycle("prev")
  end, {
    silent = true,
    desc = "Previous buffer"
  })
end

function M.cybu()
  require("cybu").setup {
    style = {
      border = "rounded"
    },
    exclude = require("core.constants").window.ignore_buf_change_filetypes
  }
end

return M
