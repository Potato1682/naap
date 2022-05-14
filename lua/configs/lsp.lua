local installer = require "nvim-lsp-installer"
local capabilities = require("cmp_nvim_lsp").update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local common_on_attach = function(client, bufnr)
  local buf_keymap = function(mode, key, action)
    vim.keymap.set(mode, key, action, { buffer = true })
  end

  local command = function(name, command, opts)
    vim.api.nvim_buf_create_user_command(0, name, command, opts or {})
  end

  local cap = client.resolved_capabilities

  if cap.declaration then
    command("LspDeclaration", function()
      vim.lsp.buf.declaration()
    end)

    buf_keymap("n", "gC", function()
      vim.lsp.buf.declaration()
    end)
  end

  if cap.goto_definition then
    command("LspDefinition", function()
      vim.lsp.buf.definition()
    end)
    command("LspPreviewDefinition", function()
      require("goto-preview").goto_preview_definition()
    end)

    buf_keymap("n", "gD", function()
      vim.lsp.buf.definition()
    end)
    buf_keymap("n", "gpD", function()
      require("goto-preview").goto_preview_definition()
    end)
  end

  if cap.type_definition then
    command("LspTypeDefinition", function()
      vim.lsp.buf.type_definition()
    end)
  end

  if cap.implementation then
    command("LspImplementation", function()
      vim.lsp.buf.implementation()
    end)
    command("LspPreviewImplementation", function()
      require("goto-preview").goto_preview_implementation()
    end)

    buf_keymap("n", "gI", function()
      vim.lsp.buf.implementation()
    end)
    buf_keymap("n", "gpI", function()
      require("goto-preview").goto_preview_implementation()
    end)
  end

  if cap.code_action then
    command("LspCodeAction", function()
      vim.cmd("CodeActionMenu")
    end)
  end

  if cap.rename then
    -- TODO
    --[[
    command(
      "LspRename",
      "lua require'lsp.rename'.rename(<f-args>)",
      { buffer = true, nargs = "?", complete = "custom,v:lua.require'lsp.completion'.rename" }
    )
    buf_keymap("n", "gr", "<cmd>LspRename<cr>")
    ]]
  end

  if cap.find_references then
    command("LspReferences", function()
      vim.lsp.buf.references()
    end)
    command("LspPreviewReferences", function()
      require("goto-preview").goto_preview_references()
    end)

    buf_keymap("n", "gR", function()
      vim.lsp.buf.references()
    end)
    buf_keymap("n", "gpR", function()
      require("goto-preview").goto_preview_references()
    end)

    buf_keymap("n", "<a-n>", function()
      require("illuminate").next_reference({ wrap = true })
    end)
    buf_keymap("n", "<a-p>", function()
      require("illuminate").next_reference({ wrap = true, reverse = true })
    end)
  end

  if cap.document_symbol then
    command("LspDocumentSymbol", function()
      vim.lsp.buf.document_symbol()
    end)
  end

  if cap.workspace_symbol then
    command("LspWorkspaceSymbol", function(args)
      vim.lsp.buf.workspace_symbol(args.args)
    end)
  end

  if cap.call_hierarchy then
    command("LspIncomingCalls", function()
      vim.lsp.buf.incoming_calls()
    end)

    command("LspOutgoingCalls", function()
      vim.lsp.buf.outgoing_calls()
    end)
  end

  if cap.code_lens then
    -- TODO
    --[[
    augroup {
      code_lens = {
        { "CursorMoved,CursorMovedI", "<buffer>", "lua vim.lsp.codelens.refresh()" },
      },
    }

    command("LspCodeLensRun", "lua vim.lsp.codelens.run()", { buffer = true })
    ]]
  end

  command("LspWorkspaceFolders", function()
    print(table.concat(vim.lsp.buf.list_workspace_folders(), "\n"))
  end)

  if cap.workspace_folder_properties.supported then
    command("LspAddWorkspaceFolder", function(args)
      vim.lsp.buf.add_workspace_folder(args.args ~= "" and vim.fn.fnamemodify(args.args, ":p"))
    end, { nargs = "?", complete = "dir" })

    command("LspRemoveWorkspaceFolder", function(args)
      vim.lsp.buf.remove_workspace_folder(unpack(args.fargs))
    end, {
      nargs = "?",
      complete = function()
        return vim.lsp.buf.list_workspace_folders()
      end
    })
  end

  command("LspDiagnosticsNext", function()
    vim.diagnostic.goto_next()
  end)
  command("LspDiagNext", function()
    vim.diagnostic.goto_next()
  end)

  command("LspDiagnosticsPrev", function()
    vim.diagnostic.goto_prev()
  end)
  command("LspDiagPrev", function()
    vim.diagnostic.goto_prev()
  end)

  command("LspDiagnosticsLine", function()
    vim.diagnostic.show_line_diagnostics()
  end)
  command("LspDiagLine", function()
    vim.diagnostic.show_line_diagnostics()
  end)

  buf_keymap("n", "gla", function()
    vim.diagnostic.show_line_diagnostics()
  end)
  buf_keymap("n", "[a", function()
    vim.diagnostic.goto_prev()
  end)
  buf_keymap("n", "]a", function()
    vim.diagnostic.goto_next()
  end)

  command("LspLog", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()", {})

  if cap.signature_help then
    command("LspSignatureHelp", function()
      vim.lsp.buf.signature_help()
    end)

    buf_keymap("i", "<C-k>", function()
      vim.lsp.buf.signature_help()
    end)
  end

  require("lsp-format").on_attach(client)

  vim.cmd("cabbrev wq execute 'Format sync' <bar> wq")

  require("inlay-hints").on_attach(client, bufnr)

  require("illuminate").on_attach(client)
end

installer.setup {}

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local default_opts = vim.tbl_extend(
  "force",
  util.default_config,
  {
    -- all lsp servers started automatically and server's autostart value is not checked if the default value is true
    -- so I set autostart=false in default and set autostart=true in servers should be started automatically before
    -- setup()
    -- I don't know how does this logic work...
    autostart = false,
    capabilities = capabilities,
    on_attach = common_on_attach
  }
)

for _, server in ipairs(installer.get_installed_servers()) do
  local opts = default_opts
  local name = server.name

  local skip_autostart_servers = {}

  local schedule_skip_autostart = function(actual, expected)
    if expected == actual then
      table.insert(skip_autostart_servers, expected)

      return true
    end

    return false
  end

  local update_opts = function(new)
    opts = vim.tbl_deep_extend(
      "force",
      opts,
      new
    )
  end

  if name == "jsonls" then
    update_opts {
      json = {
        schemas = vim.list_extend(
          O.lang.json.custom_schemas,
          require("schemastore").json.schemas()
        )
      }
    }
  end

  if name == "vuels" then
    update_opts {
      config = {
        vetur = {
          completion = {
            autoImport = true,
            useScaffoldSnippets = true
          },
          experimental = {
            templateInterPolationService = true
          }
        }
      }
    }
  end

  if schedule_skip_autostart(name, "tsserver") or schedule_skip_autostart(name, "eslint") then
    local nodejs_ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact"
    }

    local nodejs_cb = function()
      update_opts {
        autostart = util.root_pattern("package.json", "node_modules")(
          vim.api.nvim_buf_get_name(0),
          vim.api.nvim_get_current_buf()
        ) ~= nil
      }

      lspconfig[name].setup(opts)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = nodejs_ft,
      callback = nodejs_cb
    })

    if vim.tbl_contains(nodejs_ft, vim.opt_local.filetype) then
      nodejs_cb()

      goto continue
    end
  end

  if schedule_skip_autostart(name, "denols") then
    local denols_cb = function()
      update_opts {
        autostart = util.root_pattern("package.json", "node_modules")(
          vim.api.nvim_buf_get_name(0),
          vim.api.nvim_get_current_buf()
        ) == nil,
        root_dir = function(fname)
          return util.root_pattern(".git")(fname) or vim.loop.cwd()
        end,
        init_options = {
          enable = true,
          lint = true,
          unstable = true,
          codeLens = {
            implementations = true,
            references = true
          }
        }
      }

      local ok = vim.loop.fs_stat("./import_map.json")

      if ok then
        opts.init_options.importMap = "./import_map.json"
      end

      lspconfig.denols.setup(opts)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "typescript",
      callback = denols_cb
    })

    if vim.opt_local.filetype:get() == "typescript" then
      denols_cb()

      goto continue
    end
  end

  if name == "sumneko_lua" then
    local lua_dev = require("lua-dev").setup {}

    update_opts {
      on_new_config = lua_dev.on_new_config,
      settings = lua_dev.settings,
      on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false

        common_on_attach(client, bufnr)
      end
    }
  end

  if name == "clangd" then
    update_opts {
      init_options = {
        clangdFileStatus = true
      }
    }
  end

  if name == "pyright" then
    require("py_lsp").setup {}

    --[[
    local python_cb = function()
      local Path = require "plenary.path"
      local a = require "plenary.async_lib"
      local async, await = a.async, a.await

      local defer_setup = async(function(fn)
        local defer_opts = vim.deepcopy(opts)
        local venv_name, python_bin = await(fn)

        if venv_name ~= nil then
          defer_opts.settings = {
            python = {
              pythonPath = python_bin
            }
          }

          _G.CURRENT_VENV = venv_name
        end

        defer_opts.settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            }
          }
        }

        lspconfig.pyright.setup(defer_opts)
      end)

      local find_python_bin = function()
        local fname = vim.fn.expand("%:p")

        local root_files = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json"
        }

        local root_dir =
          util.root_pattern(unpack(root_files))(fname)
          or util.find_git_ancestor(fname)
          or util.path.dirname(fname)

        if root_dir == nil then
          return
        end

        local poetry_file = Path:new(join_paths(root_dir, "pyproject.toml"))
        local pipenv_file = Path:new(join_paths(root_dir, "Pipfile"))
        local venv_dir = Path:new(join_paths(root_dir, ".venv"))

        if vim.env.VIRTUAL_ENV ~= nil then
          defer_setup(async(function()
            return "venv", vim.fn.exepath "python"
          end))
        elseif poetry_file:is_file() then
          if vim.fn.executable "poetry" ~= 1 then
            return
          end

          local toml_ok, toml = pcall(require, "toml")

          if not toml_ok then
            vim.notify(
              "lua-toml rocks not installed!\nlsp will disable poetry support for pyright.",
              vim.log.levels.WARN,
              { title = "lsp" }
            )

            return
          end

          defer_setup(async(function()
            local read_ok, data = pcall(Path.read, poetry_file)

            if not read_ok then
              vim.notify(
                "Cannot read pyproject.toml!\nlsp will disable poetry support for pyright.",
                vim.log.levels.WARN,
                { title = "lsp" }
              )

              return
            end

            local parse_ok, pyproject = pcall(toml.parse, data)

            if not parse_ok then
              vim.notify(
                "malformed toml format in pyproject.toml!\nlsp will disable poetry support for pyright.",
                vim.log.levels.WARN,
                { title = "lsp" }
              )

              return
            end

            if pyproject.tool == nil or pyproject.tool.poetry == nil then
              return
            end

            local venv_path = vim.trim(vim.fn.system "poetry config virtualenvs.path")
            local venv_directory = vim.trim(vim.fn.system "poetry env list")

            if #vim.split(venv_directory, "\n") == 1 then
              return "poetry", join_paths(venv_path, vim.split(venv_directory, " ")[1], "bin", "python")
            end
          end))
        elseif pipenv_file:is_file() then
          if vim.fn.executable("pipenv") ~= 1 then
            return
          end

          defer_setup(async(function()
            local venv_directory = vim.trim(vim.fn.system "pipenv --venv")

            if venv_directory:match "No virtualenv" ~= nil then
              return
            end

            return "pipenv", join_paths(venv_directory, "bin", "python")
          end))
        elseif venv_dir:is_dir() then
          local venv_bin = Path:new(join_paths(venv_dir:expand(), "bin", "python"))

          if not venv_bin:exists() or vim.fn.executable(venv_bin:expand()) ~= 1 then
            return
          end

          defer_setup(async(function()
            return "venv", venv_bin:expand()
          end))
        end
      end

      find_python_bin()
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = python_cb
    })

    if vim.opt_local.filetype == "python" then
      python_cb()

      goto continue
    end
    ]]
  end

  if not vim.tbl_contains(skip_autostart_servers, name) then
    update_opts {
      autostart = true
    }
  end

  lspconfig[name].setup(opts)

  ::continue::
end

local null_ls = require("null-ls")

local sources = {
  null_ls.builtins.code_actions.gitsigns,
  null_ls.builtins.code_actions.gitrebase,
  null_ls.builtins.hover.dictionary
}

null_ls.setup {
  sources = sources,
  on_attach = common_on_attach
}

require("lsp-format").setup()
require("fidget").setup()
