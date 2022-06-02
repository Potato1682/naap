local M = {}

function M.bakaup_setup()
  vim.g.bakaup_backup_dir = join_paths(require("core.constants").data_dir, "backups")
  vim.g.bakaup_auto_backup = 1
end

function M.undotree_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<localleader>u", "<cmd>UndotreeToggle<cr>", "Toggle undo tree")
end

return M
