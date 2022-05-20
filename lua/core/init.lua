local constants = require("core.constants")
local data_dir = constants.data_dir
local cache_dir = constants.cache_dir
local path_sep = constants.path_sep
local uv, log_levels = vim.loop, vim.log.levels

local prepare_needed_dirs = function()
  local needed_dirs = {
    constants.data_dir .. path_sep .. "backups",
    constants.cache_dir .. path_sep .. "sessions",
    constants.cache_dir .. path_sep .. "swap",
    constants.cache_dir .. path_sep .. "undos"
  }

  for _, needed_dir in pairs(needed_dirs) do
    local needed_dir_stat, err, err_signature = uv.fs_stat(needed_dir)

    if needed_dir_stat == nil and err_signature ~= "ENOENT" then
      vim.notify(
        "Cannot stat directory: "
        .. needed_dir
        .. "\n"
        .. err,
        log_levels.ERROR, {
          title = "core"
        }
      )
    elseif err == nil and needed_dir_stat.type ~= "directory" then
      vim.notify(
        "Error while preparing "
        .. needed_dir
        .. ": This is a "
        .. needed_dir_stat.type,
        log_levels.ERROR, {
          title = "core"
        }
      )

      return
    end

    uv.fs_mkdir(needed_dir, 448)
  end
end

local finalize = function()
  require("core.lazy")
end

local setup = function()
  local ok, notify = pcall(require, "notify")

  if ok then
    vim.notify = notify
  end

  require("core.helper")
  require("editor.keymap.before")
  require("core.options")

  local pack = require("core.pack")

  prepare_needed_dirs()
  pack.disable_builtin_plugins()

  pcall(require, "impatient")

  require("core.options-before-pack")

  require("user-config.helper")

  pack.setup()

  if pack.bootstrap_plugin_manager() == "installed" then
    finalize()
  end
end

return {
  setup = setup,
  finalize = finalize
}
