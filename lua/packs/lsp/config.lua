local M = {}

-- minimal configurations, big configurations should be in lua/configs/lsp.lua

function M.lightbulb_setup()
  local augroup = vim.api.nvim_create_augroup("lightbulb", {})

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = augroup,
    callback = function()
      require("nvim-lightbulb").update_lightbulb {
        ignore = {
          "null-ls"
        }
      }
    end
  })
end

function M.lightbulb()
  require("nvim-lightbulb").setup {
    ignore = {
      "null-ls"
    },
    sign = {
      enabled = false
    },
    float = {
      enabled = true,
    }
  }
end

function M.goto_preview_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "gP", function()
    require("goto-preview").close_all_win()
  end, "Close All Preview Windows")
end

function M.goto_preview()
  local keymap = require("utils.keymap").keymap

  require("goto-preview").setup {
    post_open_hook = function()
      keymap("n", "q", "<cmd>q!<cr>", {
        buffer = true
      })
    end
  }

  require("utils.telescope").register_extension("gotopreview")
end

function M.hover_setup()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("K", function()
    require("hover").hover()
  end, "hover.nvim")
  keymap("gK", function()
    require("hover").hover_select()
  end, "hover.nvim (select provider)")

  vim.api.nvim_create_user_command("Hover", function(args)
    require("hover").hover()
  end, {
    nargs = "*",
    desc = "hover.nvim"
  })
end

function M.hover()
  require("hover").setup {
    init = function()
      require("hover.providers.lsp")
      require("hover.providers.gh")
    end,
    preview_opts = {
      border = "rounded"
    },
    title = false
  }
end

return M
