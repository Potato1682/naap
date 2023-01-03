local M = {}

-- minimal configurations, big configurations should be in lua/configs/lsp.lua

function M.mason_setup()
  local keymap = require("utils.keymap").omit("append", "n", "<leader>l", { noremap = true })

  keymap("l", function()
    vim.cmd("Mason")
  end, "Open Mason")

  keymap("M", function()
    vim.cmd("MasonLog")
  end, "Open Mason Logs")

  keymap("N", function()
    vim.cmd("NullLsInfo")
  end, "Open null-ls Info")
end

function M.mason()
  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua" },
  })

  local lsp = require("configs.lsp")

  require("mason-lspconfig").setup_handlers(lsp.lsp_handlers)

  require("mason-null-ls").setup({
    ensure_installed = { "stylua" },
  })

  require("mason-null-ls").setup_handlers({
    function(source_name, methods)
      require("mason-null-ls.automatic_setup")(source_name, methods)
    end,
  })

  require("configs.lsp.null-ls").setup()
end

function M.lightbulb_setup()
  local augroup = vim.api.nvim_create_augroup("lightbulb", {})

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = augroup,
    callback = function()
      require("nvim-lightbulb").update_lightbulb({
        ignore = {
          "null-ls",
        },
      })
    end,
  })
end

function M.lightbulb()
  require("nvim-lightbulb").setup({
    ignore = {
      "null-ls",
    },
    sign = {
      enabled = false,
    },
    float = {
      enabled = true,
    },
  })
end

function M.glance()
  require("glance").setup({
    hooks = {
      before_open = function(results, open, jump)
        local uri = vim.uri_from_bufnr(0)

        if #results == 1 then
          local target_uri = results[1].uri or results[1].targetUri

          if target_uri == uri then
            jump(results[1])
          else
            open(results)
          end
        else
          open(results)
        end
      end,
    },
  })
end

function M.inlay_hints()
  require("lsp-inlayhints").setup()
end

function M.inc_rename()
  require("inc_rename").setup()
end

return M
