local fn, uv, api, log_levels = vim.fn, vim.loop, vim.api, vim.log.levels

local constants = require("core.constants")
local config_dir = constants.config_dir
local data_dir = constants.data_dir

local plugin_manager_repo = "wbthomason/packer.nvim"
local plugin_manager_name = "packer"
local plugin_manager_identifier = "packer.nvim"
local plugin_manager_path = join_paths(data_dir, "site", "pack", plugin_manager_name, "opt", plugin_manager_identifier)

local packer_compiled_file = join_paths(config_dir, "lua", "packer_compiled.lua")
local packer_snapshots_dir = join_paths(config_dir, "snapshots")
local packer_default_snapshot = join_paths(config_dir, "snapshots", "default.json")
local packer = nil

local Pack = {}
Pack.__index = Pack

-- Load all plugin loading model from {config_dir}/lua/packs/*/plugins.lua
function Pack:load_plugins()
  self.plugins = {}
  self.rocks = {}

  local get_plugin_groups = function()
    local list = {}
    local packs_dir = join_paths(config_dir, "lua", "packs")
    local fd = uv.fs_scandir(packs_dir)

    while true do
      local name, typ = uv.fs_scandir_next(fd)

      if not name then
        -- typ contains an error message
        if typ then
          vim.notify(
            "Cannot get plugins.\n"
            .. typ,
            log_levels.ERROR, {
              title = "Pack (core)"
            }
          )
        end

        break
      end

      if typ ~= "directory" or name:sub(1, 1) == "_" then
        goto continue
      end

      local state, err = uv.fs_stat(join_paths(packs_dir, name, "plugins.lua"))

      if err or state.type ~= "file" then
        goto continue
      end

      list[#list + 1] = "packs." .. name .. ".plugins"

      ::continue::
    end

    return list
  end

  local plugin_groups = get_plugin_groups()

  for _, plugin_group in ipairs(plugin_groups) do
    local plugins = require(plugin_group)

    for plugin, conf in pairs(plugins) do
      self.plugins[#self.plugins + 1] = vim.tbl_extend("force", { plugin }, conf)
    end
  end

  self.rocks = require("packs.rocks")
end

-- Load the plugin manager, only use for packer's own command or bootstrapping
function Pack:load_plugin_manager()
  if not self.init_opts then
    self.init_opts = {
      compile_path = packer_compiled_file,
      snapshot_path = packer_snapshots_dir,
      display = {
        open_fn = function()
          return require("packer.util").float { border = "rounded" }
        end
      }
    }
  end

  if not packer then
    vim.cmd.packadd(plugin_manager_identifier)

    packer = require("packer")

    packer.init(self.init_opts)
  end

  packer.reset()

  local use = packer.use
  local use_rocks = packer.use_rocks

  self:load_plugins()

  -- Plugin manager
  use {
    plugin_manager_repo,

    module = plugin_manager_name
  }

  for _, plugin in ipairs(self.plugins) do
    use(plugin)
  end

  for _, rock in ipairs(self.rocks) do
    use_rocks(rock)
  end
end

-- Clone plugin manager if missing, else do nothing
function Pack:bootstrap_plugin_manager()
  local state = uv.fs_stat(plugin_manager_path)

  if state then
    return "installed"
  end

  local command = string.format("git clone https://github.com/%s --depth 1 %s", plugin_manager_repo, plugin_manager_path)

  vim.notify("Bootstrapping plugin manager, please wait...", log_levels.INFO, { title = "Pack (core)" })
  fn.system(command)

  self.init_opts = {
    compile_path = packer_compiled_file,
    snapshot_path = packer_snapshots_dir,
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end
    },
    -- Add this property
    snapshot = packer_default_snapshot
  }

  self:load_plugin_manager()

  self:load_snapshot()

  packer.sync()

  return "installing"
end

function Pack:load_snapshot(snapshot_file)
  snapshot_file = snapshot_file or packer_default_snapshot

  packer.rollback(snapshot_file, unpack(self.plugins))
end

local pack = {}

pack.disable_builtin_plugins = function()
  vim.g.loaded_man = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1

  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_spellfile_plugin = 1

  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1

  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

pack.bootstrap_plugin_manager = function()
  return Pack:bootstrap_plugin_manager()
end

pack.setup = function()
  local plugin_manager_state = uv.fs_stat(plugin_manager_path)
  local packer_compiled_state = uv.fs_stat(packer_compiled_file)

  if plugin_manager_state then
    if not packer_compiled_state then
      Pack:load_plugin_manager()

      packer.compile()
    else
      require("packer_compiled")
    end
  end

  local function run_packer(method)
    local function cb(opts)
      if not packer then
        Pack:load_plugin_manager()
      end

      packer[method](unpack(opts.fargs))
    end

    return cb
  end

  local keymap = require("utils.keymap").omit("append", "n", "<leader>p", { noremap = true })

  keymap("i", function()
    vim.cmd("PackerInstall")
  end, "Install plugins")

  keymap("u", function()
    vim.cmd("PackerUpdate")
  end, "Update plugins")

  keymap("l", function()
    vim.cmd("PackerClean")
  end, "Clean plugins")

  keymap("p", function()
    vim.cmd("PackerStatus")
  end, "Show plugins status")

  keymap("c", function()
    vim.cmd("PackerCompile")
  end, "Compile plugins detail")

  keymap("C", function()
    vim.cmd("PackerCompile profile=true")
  end, "Compile plugins detail with profiling")

  keymap("s", function()
    vim.cmd("PackerSync")
  end, "Sync plugins")

  keymap("P", function()
    vim.cmd("PackerProfile")
  end, "Show plugins profiling result")

  keymap("S", function()
    vim.cmd("PackerSnapshot")
  end, "Create a snapshot of plugins")

  vim.api.nvim_create_user_command("PackerInstall", run_packer "install", { desc = "[Packer] Install plugins" })
  vim.api.nvim_create_user_command("PackerUpdate", run_packer "update", { desc = "[Packer] Update plugins" })
  vim.api.nvim_create_user_command("PackerClean", run_packer "clean", { desc = "[Packer] Clean plugins" })
  vim.api.nvim_create_user_command("PackerStatus", run_packer "status", { desc = "[Packer] Show plugins status" })
  vim.api.nvim_create_user_command("PackerCompile", run_packer "compile", { desc = "[Packer] Compile plugins detail", nargs = "*" })
  vim.api.nvim_create_user_command("PackerSync", run_packer "sync", { desc = "[Packer] Sync plugins" })
  vim.api.nvim_create_user_command("PackerLoad", run_packer "loader", { desc = "[Packer] Load a plugin", nargs = "+" })
  vim.api.nvim_create_user_command("PackerProfile", run_packer "profile_output", { desc = "[Packer] Show plugins profiling result" })
  vim.api.nvim_create_user_command("PackerSnapshot", run_packer "snapshot", { desc = "[Packer] Create a snapshot of plugins", nargs = "*" })
  vim.api.nvim_create_user_command("PackerSnapshotRollback", run_packer "rollback", { desc = "[Packer] Rollback from the snapshot" })

  require("editor.events.pack").setup()
end

return pack
