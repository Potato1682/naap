local M = {}

function M.trld()
  require("trld").setup({
    position = "bottom",
  })
end

function M.highlight()
  require("nvim-custom-diagnostic-highlight").setup({
    highlight_group = "Comment",
  })
end

return M
