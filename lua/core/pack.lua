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

      if typ ~= "directory" then
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
  self.init_opts = vim.tbl_deep_extend("force", self.init_opts or {}, {
    compile_path = packer_compiled_file,
    snapshot_path = packer_snapshots_dir,
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end
    }
  })

  if not packer then
    vim.cmd("packadd " .. plugin_manager_identifier)

    packer = require("packer")

    packer.init(self.init_opts)
  end

  packer.reset()

  local use = packer.use
  local use_rocks = packer.use_rocks

  self:load_plugins()

  -- Plugin manager
  use { plugin_manager_repo, opt = true }

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

  if not state then
    local command = string.format("git clone https://github.com/%s --depth 1 %s", plugin_manager_repo, plugin_manager_path)

    vim.notify("Bootstrapping plugin manager, please wait...", log_levels.INFO, { title = "Pack (core)" })
    fn.system(command)

    self.init_opts = {
      snapshot = default_snapshot_file
    }

    self:load_plugin_manager()

    packer.sync()

    return "installing"
  end

  return "installed"
end

local pack = setmetatable(Pack, {
  __index = function(_, key)
    Pack:load_plugin_manager()

    return packer[key]
  end
})

pack.disable_builtin_plugins = function()
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

  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
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

  api.nvim_create_user_command(
    "PackerSnapshot",
    function(args)
      require("core.pack").snapshot(unpack(args.fargs))
    end, {
      nargs = "+",
      complete = function()
        return require("packer.snapshot").completion.create()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerSnapshotRollback",
    function(args)
      require("core.pack").rollback(unpack(args.fargs))
    end, {
      nargs = "+",
      complete = function()
        return require("packer.snapshot").completion.rollback()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerSnapshotDelete",
    function(args)
      require("packer.snapshot").delete(unpack(args.fargs))
    end, {
      nargs = "+",
      complete = function()
        return require("packer.snapshot").completion.snapshot()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerInstall",
    function(args)
      require("core.pack").install(unpack(args.fargs))
    end, {
      nargs = "*",
      complete = function()
        return packer.plugin_complete()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerUpdate",
    function(args)
      require("core.pack").update(unpack(args.fargs))
    end, {
      nargs = "*",
      complete = function()
        return packer.plugin_complete()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerSync",
    function(args)
      require("core.pack").sync(unpack(args.fargs))
    end, {
      nargs = "*",
      complete = function()
        return packer.plugin_complete()
      end
    }
  )
  api.nvim_create_user_command(
    "PackerClean",
    function()
      require("core.pack").clean()
    end, {}
  )
  api.nvim_create_user_command(
    "PackerCompile",
    function(args)
        require("core.pack").compile(args.args)
    end, {
      nargs = "*"
    }
  )
  api.nvim_create_user_command(
    "PackerStatus",
    function()
      require("core.pack").status()
    end, {}
  )
  api.nvim_create_user_command(
    "PackerProfile",
    function()
      require("core.pack").profile_output()
    end, {}
  )
  api.nvim_create_user_command(
    "PackerLoad",
    function(args)
      require("core.pack").loader(unpack(args.fargs), args.bang == true)
    end, {
      nargs = "+",
      complete = function()
        return packer.loader_complete()
      end
    }
  )
end

return pack
