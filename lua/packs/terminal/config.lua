local M = {}

function M.toggleterm_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<C-t>", function()
    vim.cmd("ToggleTerm")
  end, "Open Terminal", {
    silent = true,
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
