local M = {}

local keymap = require("utils.keymap")

function M.mode_only(mode, opts)
  opts = opts or {}

  return keymap.omit("append", mode, "", opts)
end

function M.leader(mode, prefix, opts)
  opts = opts or {}

  return keymap.omit("append", mode, "<leader>" .. prefix, opts)
end

function M.localleader(mode, prefix, opts)
  opts = opts or {}

  return keymap.omit("append", mode, "<localleader>" .. prefix, opts)
end

return M
