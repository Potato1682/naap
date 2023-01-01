local M = {}

function M.test()
  require("neotest").setup({
    adapters = {
      require("neotest-vim-test")({}),
    },
  })
end

return M
