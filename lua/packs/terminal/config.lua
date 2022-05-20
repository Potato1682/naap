local M = {}

function M.toggleterm_setup()
  vim.keymap.set("n", "<C-t>", function(opts)
    vim.cmd [[execute v:count1 . "ToggleTerm"]]
  end, {
    silent = true,
    desc = "Open Terminal"
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
