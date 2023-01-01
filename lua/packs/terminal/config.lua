local M = {}

function M.toggleterm_setup()
  local keymap = require("utils.keymap").omit("append", "n", "", { noremap = true })

  keymap("<C-t>", "<cmd>ToggleTerm<cr>", "Open Terminal")
end

function M.toggleterm()
  require("toggleterm").setup({
    open_mapping = "<C-t>",
    float_opts = {
      border = require("utils.border").get_border_char_and_hl("rounded"),
      winblend = 3,
    },
  })
end

return M
