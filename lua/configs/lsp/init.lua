local M = {}

local uv = vim.loop

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local on_attach = require("configs.lsp.on_attach")

local is_nodejs_project = require("utils.nodejs").is_nodejs_project

M.default_opts = {
  capabilities = require("configs.lsp.capabilities"),
  on_attach = require("configs.lsp.on_attach").common_on_attach,
}

function M.create_opts_override(new)
  return vim.tbl_deep_extend("force", M.default_opts, new)
end

M.lsp_handlers = {
  function(server_name)
    lspconfig[server_name].setup(M.default_opts)
  end,

  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup(M.create_opts_override({
      before_init = require("neodev.lsp").before_init,
      on_attach = on_attach.without_server_formatting,
      settings = {
        Lua = {
          hint = {
            enable = true,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }))
  end,

  ["clangd"] = function()
    lspconfig.clangd.setup(M.create_opts_override({
      init_options = {
        clangdFileStatus = true,
      },
    }))
  end,

  ["jsonls"] = function()
    lspconfig.jsonls.setup(M.create_opts_override({
      json = {
        schemas = vim.list_extend(O.lang.json.custom_schemas, require("schemastore").json.schemas()),
        validate = {
          enable = true,
        },
      },
    }))
  end,

  ["yamlls"] = function()
    lspconfig.yamlls.setup(M.create_opts_override({
      settings = {
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
        yaml = {
          validate = true,
          format = {
            enable = false,
          },
          hover = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemaDownload = {
            enable = true,
          },
          schemas = {},
        },
      },
    }))
  end,

  ["pyright"] = function()
    require("py_lsp").setup({})
  end,

  ["vuels"] = function()
    lspconfig.vuels.setup(M.create_opts_override({
      config = {
        vetur = {
          completion = {
            autoImport = true,
            useScaffoldSnippets = true,
          },
          experimental = {
            templateInterPolationService = true,
          },
        },
      },
    }))
  end,

  ["denols"] = function()
    if is_nodejs_project() then
      lspconfig.denols.setup({ autostart = false })

      return
    end

    local import_map_path = join_paths(".", "import_map.json")
    local has_import_map = not not uv.fs_stat(import_map_path)

    lspconfig.denols.setup(M.create_opts_override({
      root_dir = function(fname)
        return util.root_pattern(".git")(fname) or uv.cwd()
      end,
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
        codeLens = {
          implementations = true,
          references = true,
        },
        importMap = has_import_map and import_map_path or nil,
      },
    }))
  end,

  ["tsserver"] = function()
    if not is_nodejs_project() then
      lspconfig.tsserver.setup({ autostart = false })

      return
    end

    lspconfig.tsserver.setup(M.create_opts_override({
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    }))
  end,
}

function M.change_floating_border()
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  -- change lsp popup window border
  win.default_opts = function(options)
    local opts = _default_opts(options)

    opts.border = "rounded"

    return opts
  end
end

M.change_floating_border()
require("editor.keymap.lsp")

return M
