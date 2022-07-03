local M = {}

function M.toggleterm()
  require("toggleterm").setup {
    open_mapping = "<C-t>",
    float_opts = {
      border = require("utils.border").get_border_char_and_hl("rounded"),
      winblend = 3
    }
  }
end

return M
