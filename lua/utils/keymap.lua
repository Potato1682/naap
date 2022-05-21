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

return M
