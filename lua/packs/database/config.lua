local M = {}

function M.dbui_setup()
  vim.keymap.set("n", "<leader>D", function()
    vim.cmd("DBUI")
  end, {
    desc = "Databases"
  })

  vim.g.dbs = vim.tbl_deep_extend("force", vim.g.dbs or {}, O.database.servers)
end

return M
