local M = {}

function M.toggleterm_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<C-t>", function()
    vim.cmd("ToggleTerm")
  end, "Open Terminal", {
    silent = true,
  })

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      vim.opt_local.spell = false
    end
  })
end

function M.toggleterm()
  require("toggleterm").setup {
    float_opts = {
      border = "curved"
    }
  }
end

return M
