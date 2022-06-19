local M = {}

function M.cmp()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local str = require("cmp.utils.str")
  local context = require("cmp.config.context")
  local luasnip = require("luasnip")
  local char = require("utf8").char

  local kind_mapping = {
    Class = "   ",
    Color = "   ",
    Constant = "   ",
    Constructor = "   ",
    Enum = "   ",
    EnumMember = "   ",
    Event = "   ",
    Field = " ﰠ  ",
    File = "   ",
    Folder = "   ",
    Function = "   ",
    Interface = "ﰮ  ",
    Keyword = "   ",
    Method = "   ",
    Module = " {} ",
    Operator = "   ",
    Property = "   ",
    Reference = "  ",
    Snippet = "  ",
    Struct = "  ",
    Text = "   ",
    TypeParameter = "<T>",
    Unit = " 塞 ",
    Value = "   ",
    Variable = "   ",
  }

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup {
    enabled = function()
      if require("cmp_dap").is_dap_buffer() then
        return true
      end

      if vim.opt_local.buftype:get() == "prompt" then
        return false
      end

      if vim.api.nvim_get_mode().mode == "c" then
        return true
      end

      if context.in_treesitter_capture("Comment") or context.in_syntax_group("Comment") then
        return false
      end

      return true
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
    formatting = {
      fields = {
        cmp.ItemField.Kind,
        cmp.ItemField.Abbr,
        cmp.ItemField.Menu
      },
      format = function(entry, vim_item)
        vim_item.kind = kind_mapping[vim_item.kind] or vim_item.kind

        -- Code from max397574/ignis-nvim
        local word = entry:get_insert_text()

        if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
          word = vim.lsp.util.parse_snippet(word)
        end

        word = str.oneline(word)

        local max = 50

        if string.len(word) >= max then
          local before = string.sub(
            word,
            1,
            math.floor((max - 3) / 2)
          )

          word = before .. "..."
        end

        if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
            and vim_item.abbr:sub(-1, -1) == "~" then
          word = word .. "~"
        end

        vim_item.abbr = word

        -- Source-specific formatting
        vim_item.dup = ({
          buffer = 1,
          path = 1,
          nvim_lsp = 0
        })[entry.source.name] or 0

        if entry.source.name == "cmp_tabnine" then
          vim_item.kind = " " .. char(0xe315) .. " "

          if entry.completion_item.data and entry.completion_item.data.detail then
            vim_item.menu = entry.completion_item.data.detail
          end
        end

        if entry.source.name == "copilot" then
          vim_item.kind = " " .. char(0xfbd9) .. " "
        end

        return vim_item
      end
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
        require("copilot_cmp.comparators").score,
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
      ["<C-j>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-k>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping(function()
        if not cmp.confirm { select = false } then
          require("pairs.enter").type()
        end
      end)
    },
    sources = {
      -- Copilot
      { name = "copilot" },

      -- LSP
      { name = "nvim_lsp" },

      -- Snippets
      { name = "luasnip" },

      -- Tabnine
      { name = "cmp_tabnine" },

      -- DAP
      { name = "dap" }
    },
    experimental = {
      ghost_text = true
    }
  }

  local kind = cmp.lsp.CompletionItemKind

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
      }),
      view = {
        entries = { name = "wildmenu", separator = " · " }
      },
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

  tabnine:setup {
    show_prediction_strength = true
  }
end

function M.cmp_git()
  require("cmp_git").setup {}
end

function M.copilot()
  vim.schedule(function()
    require("copilot").setup()
  end)
end

function M.dadbod()
  local augroup = vim.api.nvim_create_augroup("dadbod-completion", {})

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "sql,mysql,plsql",
    callback = function()
      require("cmp").setup_buffer {
        sources = { {
          name = "vim-dadbod-completion"
        } }
      }
    end
  })
end

return M
