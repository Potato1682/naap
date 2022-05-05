local M = {}

function M.hlslens_setup()
  local map = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs)
  end

  map("n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>")
  map("N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>")

  map("*", function()
    require("hlslens").start()
  end)
  map("#", function()
    require("hlslens").start()
  end)
  map("g*", function()
    require("hlslens").start()
  end)
  map("g#", function()
    require("hlslens").start()
  end)
end

function M.hlslens()
  require("scrollbar.handlers.search").setup()
end

return M
