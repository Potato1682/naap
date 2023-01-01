local nvim_dev = {}

-- nvim-dev plugins should be lazy-loaded to improve normal UX

nvim_dev["dstein64/vim-startuptime"] = {
  cmd = "StartupTime",

  config = function()
    vim.g.startuptime_tries = 10
  end,
}

nvim_dev["tamton-aquib/keys.nvim"] = {
  cmd = "KeysToggle",

  config = function()
    require("keys").setup({})
  end,
}

nvim_dev["milisims/nvim-luaref"] = {}
nvim_dev["nanotee/luv-vimdocs"] = {}

return nvim_dev
