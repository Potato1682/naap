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
  local keymap_n = require("utils.keymap").omit("prepend", "n", "b", { silent = true })
  local keymap = require("utils.keymap").omit("insert", { "n", "v" }, "<^%Tab>", { silent = true })

  keymap_n("[", function()
    require("cybu").cycle("next")
  end, "Next buffer")
  keymap_n("]", function()
    require("cybu").cycle("prev")
  end, "Prev buffer")

  keymap("", function()
    require("cybu").cycle("next", "last_used")
  end, "Next last used buffer")

  keymap("S-", function()
    require("cybu").cycle("prev", "last_used")
  end, "Previous last used buffer")
end

function M.cybu()
  require("cybu").setup {
    behavior = {
      mode = {
        default = {
          view = "paging"
        },
        last_used = {
          switch = "immediate",
          view = "paging"
        }
      }
    },
    style = {
      border = "rounded",
    },
    exclude = require("core.constants").window.ignore_buf_change_filetypes
  }
end

return M
