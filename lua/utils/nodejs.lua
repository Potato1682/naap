local M = {}

function M.is_nodejs_project()
  local ok, util = pcall(require, "lspconfig.util")

  if not ok then
    return false
  end

  return util.root_pattern("package.json", "node_modules")(vim.api.nvim_buf_get_name(0)) ~= nil
end

return M
