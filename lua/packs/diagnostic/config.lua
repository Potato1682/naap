local M = {}

function M.highlight()
  require("nvim-custom-diagnostic-highlight").setup({
    highlight_group = "Comment",
  })
end

return M
