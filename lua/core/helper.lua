require("user-config.helper")

local path_sep = require("core.constants").path_sep

function _G.join_paths(...)
  return table.concat({ ... }, path_sep)
end
