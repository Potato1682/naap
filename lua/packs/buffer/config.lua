local M = {}

function M.bufdelete_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>q", function()
    require("bufdelete").bufdelete(0, false)
  end, "Close Buffer")
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
