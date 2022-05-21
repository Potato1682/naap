local os_name
local is_windows
local is_linux

if jit then
  os_name = jit.os

  is_windows = os_name == "Windows"
  is_linux = os_name == "Linux"
else
  os_name = vim.loop.os_uname().sysname

  is_windows = os_name == "Windows" or os_name == "Windows_NT"
  is_linux = os_name == "linux"
end

local path_sep = is_windows and "\\" or "/"
local config_dir = vim.fn.stdpath("config")
local cache_dir = vim.fn.stdpath("cache")
local data_dir = vim.fn.stdpath("data")

local quit_with_q = {
  buftypes = {
    "quickfix"
  },
  filetypes = {
    -- vim-dadbod
    "dbout",

    -- lsp
    "lspinfo",

    -- vim-startuptime
    "startuptime"
  }
}

local ignore_buf_change_filetypes = vim.tbl_extend("force", quit_with_q, {
  -- nvim-dap
  "dbui",

  -- neo-tree.nvim
  "neo-tree",

  -- quickfix
  "qf"
})

return {
  os_name = os_name,
  is_windows = is_windows,
  is_linux = is_linux,
  path_sep = path_sep,
  config_dir = config_dir,
  cache_dir = cache_dir,
  data_dir = data_dir,
  window = {
    quit_with_q = quit_with_q,
    ignore_buf_change_filetypes = ignore_buf_change_filetypes
  }
}
