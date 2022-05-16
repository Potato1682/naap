local update = require("cmp_nvim_lsp").update_capabilities

return setmetatable(update(
  vim.lsp.protocol.make_client_capabilities()
), {
  __call = function(_, override)
    return update(
      vim.lsp.protocol.make_client_capabilities(),
      override
    )
  end
})
