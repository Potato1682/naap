local M = {}

function M.numb()
  require("numb"). setup {
    show_cursorline = false
  }
end

function M.range_highlight()
  require("range-highlight").setup()
end

return M
