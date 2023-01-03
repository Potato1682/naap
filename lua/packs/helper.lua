local M = {}

local in_vscode_cache = vim.fn.exists("g:vscode") == 0

function M.in_vscode()
  return in_vscode_cache
end

return M
