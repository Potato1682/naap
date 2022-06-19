local function update_fold(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  return capabilities
end

local update_cmp = require("cmp_nvim_lsp").update_capabilities

return setmetatable(update_fold(update_cmp(
  vim.lsp.protocol.make_client_capabilities()
)), {
  __call = function(_, override)
    local new_capabilities = vim.tbl_deep_extend("force", update_fold(update_cmp(
      vim.lsp.protocol.make_client_capabilities()
    )), override)
  end
})
