local M = {}

local check_desc_opts_type = function(desc, opts)
  desc = desc or ""

  if type(desc) == "table" and not opts then
    opts = desc
  else
    if type(desc) == "string" then
      opts = vim.tbl_deep_extend("force", opts or {}, { desc = desc })
    end
  end

  return desc, opts
end

function M.keymap(mode, key, action, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  vim.keymap.set(mode, key, action, opts)
end

-- Create a new omitted keymap function.
---@param behavior string Decides how the omitted keymap behaves:
---       "append" - The new keymap will be appended to the current keymap
---       "prepend" - The new keymap will be prepended to the current keymap.
---       "insert" - The new keymap will be inserted into the current keymap.
---                  The new keymap will be replaced from "^%" character.
---       "remove" - The new keymap will be removed from the current keymap.
---@param mode any #string|table The vim mode target.
---@param omit_key string The key to omit.
---@param omit_opts any #table The options to omit.
function M.omit(behavior, mode, omit_key, omit_opts)
  omit_opts = omit_opts or {}

  if behavior == "append" then
    return function(key, action, desc, opts)
      opts = opts or {}

      M.keymap(mode, omit_key .. key, action, desc, vim.tbl_deep_extend("force", omit_opts, opts))
    end
  elseif behavior == "prepend" then
    return function(key, action, desc, opts)
      opts = opts or {}

      M.keymap(mode, key .. omit_key, action, desc, vim.tbl_deep_extend("force", omit_opts, opts))
    end
  elseif behavior == "insert" then
    return function(key_to_insert, action, desc, opts)
      local key = omit_key:gsub("%^%%", key_to_insert)

      opts = opts or {}

      M.keymap(mode, key, action, desc, vim.tbl_deep_extend("force", omit_opts, opts))
    end
  elseif behavior == "remove" then
    return function(_, action, desc, opts)
      opts = opts or {}

      M.keymap(mode, omit_key, "", desc, vim.tbl_deep_extend("force", omit_opts, opts))
    end
  else
    error("Unknown behavior: " .. tostring(behavior))
  end
end

return M
