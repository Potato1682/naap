local M = {}

function M.check_git_workspace()
  local current_path = vim.fn.expand("%:p:h")
  local git_dir = vim.fn.finddir(".git", current_path .. ";")

  return git_dir and #git_dir > 0 and #git_dir < #current_path
end

return M

