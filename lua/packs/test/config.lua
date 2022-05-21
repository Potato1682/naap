local M = {}

function M.test()
  require("nvim-test").setup {
    term = "toggleterm"
  }
end

return M
