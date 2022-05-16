local api = vim.api
local win = require("lspconfig.ui.windows")
local _default_opts = win.default_opts

win.default_opts = function(options)
  local opts = _default_opts(options)

  opts.border = "rounded"

  return opts
end

local message_severity = {
  "error",
  "warn",
  "info",
  "info"
}

vim.lsp.handlers["window/showMessage"] = function(_, method, params)
  vim.notify(method.message, message_severity[params.type])
end

vim.keymap.set("n", "<leader>lI", "<cmd>LspInfo<cr>", { silent = true, desc = "LSP Information" })

local installer = require "nvim-lsp-installer"
local capabilities = require("configs.lsp.capabilities")

installer.setup {}

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local on_attach = require("configs.lsp.on_attach")
local is_nodejs_project = require("utils.nodejs")

local default_opts = vim.tbl_extend(
  "force",
  util.default_config, {
  -- all lsp servers started automatically and server's autostart value is not checked if the default value is true
  -- so I set autostart=false in default and set autostart=true in servers should be started automatically before
  -- setup()
  -- I don't know how does this logic work...
  autostart = false,
  capabilities = capabilities,
  on_attach = on_attach.common_on_attach
})

local nodejs_augroup = api.nvim_create_augroup("nodejs", {
  clear = true
})
local denols_augroup = api.nvim_create_augroup("denols", {
  clear = true
})

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
        autostart = is_nodejs_project()
      }

      lspconfig[name].setup(opts)
    end

    api.nvim_create_autocmd("FileType", {
      pattern = nodejs_ft,
      group = nodejs_augroup,
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
        autostart = not is_nodejs_project(),
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

      local import_map_path = join_paths(".", "import_map.json")

      if vim.loop.fs_stat(import_map_path) then
        opts.init_options.importMap = import_map_path
      end

      lspconfig.denols.setup(opts)
    end

    api.nvim_create_autocmd("FileType", {
      pattern = "typescript",
      group = denols_augroup,
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
      on_attach = on_attach.without_server_formatting
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

    api.nvim_create_autocmd("FileType", {
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

require("configs.lsp.null-ls").setup()

require("lsp_signature").setup {
  bind = true,
  handler_opts = {
    border = "rounded"
  },
  fix_pos = true,
  hint_enable = false
}
require("lsp-format").setup()
require("fidget").setup {
  sources = {
    ["null-ls"] = {
      ignore = true
    }
  },
  text = {
    spinner = "dots"
  }
}
