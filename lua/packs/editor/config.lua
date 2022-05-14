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

function M.houdini()
  require("houdini").setup {
    mappings = {
      "jk",
      "AA",
      "II"
    },
    escape_sequences = {
      i = function(first, second)
        local seq = first .. second


        if seq == "AA" then
          return "<BS><BS><End>"
        end

        if seq == "II" then
          return "<BS><BS><Home>"
        end

        return "<BS><BS><ESC>"
      end
    }
  }
end

return M
