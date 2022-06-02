local M = {}

function M.bufdelete_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>q", function()
    require("bufdelete").bufdelete(0, false)
  end, "Close Buffer")
end

function M.incline()
  local char = require("utf8").char
  local icons = require("nvim-web-devicons")

  require("incline").setup {
    render = function(props)
      local name = vim.api.nvim_buf_get_name(props.buf)
      local icon, hl

      if name == "" then
        name = "[No Name]"
        icon = char(0xf723)
        hl = "black"
      else
        name = vim.fn.fnamemodify(name, ":t")
        icon, hl = icons.get_icon_color(name, vim.fn.fnamemodify(name, ":e"))
      end

      local result = {
        { icon .. " ", guifg = hl },
        { name, group = "CursorLine" },
        vim.bo[props.buf].modified
            and { " " .. char(0x25cf), guifg = "green" }
            or { "  " }
      }

      return result
    end,
    hide = {
      cursorline = true
    },
    window = {
      margin = {
        horizontal = 3,
        vertical = 0
      },
      winhighlight = {
        Normal = "CursorLine"
      },
      zindex = 100
    },
  }
end

function M.cybu_setup()
  local keymap = require("utils.keymap").omit("insert", "n", "<^%Tab>", { silent = true })

  keymap("", function()
    require("cybu").cycle("next")
  end, "Next buffer")

  keymap("S-", function()
    require("cybu").cycle("prev")
  end, "Previous buffer")
end

function M.cybu()
  require("cybu").setup {
    style = {
      border = "rounded"
    },
    exclude = require("core.constants").window.ignore_buf_change_filetypes
  }
end

return M
