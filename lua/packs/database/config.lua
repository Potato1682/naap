local M = {}

function M.dbui_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>D", function()
    vim.cmd("DBUI")
  end, "Databases")

  vim.g.dbs = vim.tbl_deep_extend("force", vim.g.dbs or {}, O.database.servers)
end

return M
