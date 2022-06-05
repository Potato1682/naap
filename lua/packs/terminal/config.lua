local M = {}

function M.toggleterm_setup()
  local keymap = require("utils.keymap").keymap

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      vim.opt_local.spell = false
      vim.opt_local.signcolumn = "no"
    end
  })
end

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
