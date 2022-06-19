local M = {}

function M.setup()
  -- Use filetype.lua, which will be stable in Neovim 0.8
  if vim.fn.has("nvim-0.8") == 1 then
    vim.g.do_filetype_lua = 1
    vim.g.did_load_filetypes = 0
  end
end

return M
