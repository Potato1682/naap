local M = {}

function M.bufdelete_setup()
  vim.keymap.set("n", "<leader>q", function()
    require("bufdelete").bufdelete(0, false)
  end, {
    desc = "Close Buffer"
  })
end

return M
