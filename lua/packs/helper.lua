local M = {}

function M.in_vscode()
  return vim.fn.exists("g:vscode") == 0
end

return M

