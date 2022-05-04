local nvim_dev = {}

-- nvim-dev plugins should be lazy-loaded to improve normal UX
nvim_dev["dstein64/vim-startuptime"] = {
  cmd = "StartupTime",

  config = function()
    vim.g.startuptime_tries = 10
  end
}

return nvim_dev

