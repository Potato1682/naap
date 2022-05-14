local M = {}

function M.cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup {
    enabled = function()
      local context = require("cmp.config.context")

      if vim.api.nvim_get_mode().mode == "c" then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
          and (vim.opt_local.buftype:get() ~= "prompt"
          or require("cmp_dap").is_dap_buffer())
      end
    end,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("cmp_tabnine.compare"),
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order
      }
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true })
    },
    sources = {
      -- LSP
      { name = "nvim_lsp" },

      -- Snippets
      { name = "luasnip" },

      -- Tabnine
      { name = "tabnine" },

      -- DAP
      { name = "dap" }
    }
  }

  local path_extension
  local cmd_comparators = {
    cmp.config.compare.offset,
    cmp.config.compare.exact,
    cmp.config.compare.score,
    cmp.config.compare.recently_used,
    cmp.config.compare.kind,
    cmp.config.compare.sort_text,
    cmp.config.compare.length,
    cmp.config.compare.order
  }

  if vim.fn.executable("fd") == 1 then
    PLoader("cmp-fuzzy-path")

    table.insert(cmd_comparators, require("cmp_fuzzy_path.compare"))

    path_extension = "fuzzy_path"
  else
    PLoader("cmp-path")

    path_extension = "path"
  end

  cmp.setup.cmdline(":", {
    sorting = {
      priority_weight = 2,
      comparators = cmd_comparators
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = path_extension }
    }, {
      { name = "cmdline" },
      { name = "cmdline_history" }
    })
  })

  for _, cmd_type in ipairs({ "/", "?" }) do
    cmp.setup.cmdline(cmd_type, {
      sorting = {
        priority_weight = 2,
        comparators = {
          require("cmp_fuzzy_buffer.compare"),
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order
        }
      },
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" }
      }, {
        { name = "fuzzy_buffer" },
        { name = "cmdline_history" }
      })
    })
  end

  cmp.setup.cmdline("@", {
    sources = {
      { name = "cmdline_history" }
    }
  })
end

function M.tabnine()
  local tabnine = require("cmp_tabnine.config")

  tabnine:setup {}
end

function M.cmp_git()
  require("cmp_git").setup {}
end

return M
