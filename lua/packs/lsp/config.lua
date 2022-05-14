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
  vim.keymap.set("n", "gP", function()
    require("goto-preview").close_all_win()
  end)
end

function M.goto_preview()
  require("goto-preview").setup {
    default_mappings = true
  }
end

function M.trld()
  vim.diagnostic.config {
    virtual_text = false,
    underline = {
      severity = {
        min = vim.diagnostic.severity.INFO
      }
    },
    signs = false
  }

  require("trld").setup {
    position = "bottom"
  }
end

function M.hover_setup()
  vim.keymap.set("n", "K", function()
    require("hover").hover()
  end, {
    desc = "hover.nvim"
  })
  vim.keymap.set("n", "gK", function()
    require("hover").hover_select()
  end, {
    desc = "hover.nvim (select)"
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
