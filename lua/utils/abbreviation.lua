local M = {}

function M.abbrev(mode, lhs, rhs)
  vim.cmd(string.format("%sabbrev %s %s", mode, lhs, rhs))
end

return M
