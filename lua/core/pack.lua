local fn, uv, api, log_levels = vim.fn, vim.loop, vim.api, vim.log.levels

local constants = require("core.constants")
local config_dir = constants.config_dir
local data_dir = constants.data_dir

local packer_compiled_file = join_paths(config_dir, "lua", "packer_compiled")
local packer_snapshots_dir = join_paths(config_dir, "snapshots")
local packer_default_snapshot = join_paths(config_dir, "snapshots", "default.json")
local packer = nil

local Pack = {}
Pack.__index = Pack

function Pack:ensure_plugin_manager()
end

local pack = setmetatable(Pack, {
  __index = function(_, key)
    return nil
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
end

return pack
