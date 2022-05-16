local M = {}

function M.cycle_setup()
  vim.keymap.set("n", "<CR>", function()
    require("fold-cycle").open()
  end, {
    desc = "Open Folding"
  })
  vim.keymap.set("n", "<BS>", function()
    require("fold-cycle").close()
  end, {
    desc = "Close Folding"
  })
  vim.keymap.set("n", "zC", function()
    require("fold-cycle").close_all()
  end, {
    desc = "Close All Folding"
  })
end

function M.cycle()
  require("fold-cycle").setup()
end

function M.pretty()
  require("pretty-fold").setup()
  require("pretty-fold.preview").setup()
end

return M
