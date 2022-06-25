local M = {}

function M.cycle_setup()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("<CR>", function()
    require("fold-cycle").open()
  end, "Open Folding")
  keymap("<BS>", function()
    require("fold-cycle").close()
  end, "Close Folding")
  keymap("zC", function()
    require("fold-cycle").close_all()
  end, "Close All Folding")
end

function M.cycle()
  require("fold-cycle").setup()
end

function M.ufo()
  local char = require("utf8").char

  require("ufo").setup {
    fold_virt_text_handler = function(virtual_text, lnum, endlnum, width, truncate)
      local new_virtual_text = {}
      local foldlnum = endlnum - lnum
      local suffix = (" %s %d lines"):format(char(0x22ef), foldlnum)
      local suffix_width = vim.fn.strdisplaywidth(suffix)
      local target_width = width - suffix_width
      local cursor_width = 0

      for _, chunk in ipairs(virtual_text) do
        local chunk_text = chunk[1]
        local chunk_width = vim.fn.strdisplaywidth(chunk_text)

        if target_width > cursor_width + chunk_width then
          table.insert(new_virtual_text, chunk)
        else
          chunk_text = truncate(chunk_text, target_width - cursor_width)

          local hl_group = chunk[2]

          table.insert(new_virtual_text, {
            chunk_text,
            hl_group,
          })

          chunk_width = vim.fn.strdisplaywidth(chunk_text)

          if cursor_width + chunk_width < target_width then
            suffix = suffix .. (" "):rep(target_width - cursor_width - chunk_width)
          end

          break
        end

        cursor_width = cursor_width + chunk_width
      end

      table.insert(new_virtual_text, {
        suffix,
        "UfoFoldedEllipsis",
      })

      return new_virtual_text
    end
  }

  vim.schedule(function()
    vim.api.nvim_set_hl(0, "Folded", {
      foreground = "#5c6370",
      background = "#342f50"
    })
    vim.api.nvim_set_hl(0, "UfoFoldedBg", {
      background = "#342f50"
    })
  end)
end

return M
