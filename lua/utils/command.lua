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

function M.current_buf_command(name, command, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  vim.api.nvim_buf_create_user_command(0, name, command, opts)
end

function M.command(name, command, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  if opts.buffer then
    if type(opts.buffer) == "boolean" then
      vim.api.nvim_buf_create_user_command(0, name, command, opts)
    elseif type(opts.buffer) == "number" then
      vim.api.nvim_buf_create_user_command(opts.buffer, name, command, opts)
    end
  else
    vim.api.nvim_create_user_command(name, command, opts)
  end
end

return M
