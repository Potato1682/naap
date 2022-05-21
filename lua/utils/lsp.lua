local M = {}

function M.find_client(name)
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == name then
      return client
    end
  end
end

return M
