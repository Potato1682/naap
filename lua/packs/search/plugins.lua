local search = {}

search["nvim-telescope/telescope.nvim"] = {
  module = "telescope",

  setup = function()
    require("packs.search.config").telescope_setup()
  end,

  config = function()
    require("packs.search.config").telescope()
  end
}

-- Sorter
search["nvim-telescope/telescope-fzf-native.nvim"] = {
  after = "telescope.nvim",

  run = "make",

  config = function()
    require("packs.search.config").telescope_fzf_native()
  end
}

-- Files
search["nvim-telescope/telescope-media-files.nvim"] = {
  after = "telescope.nvim",

  disable = not require("core.constants").is_linux,

  setup = function()
    require("packs.search.config").telescope_media_files_setup()
  end,

  config = function()
    require("packs.search.config").telescope_media_files()
  end
}

-- Pickers
search["nvim-telescope/telescope-dap.nvim"] = {
  after = "telescope.nvim",

  setup = function()
    require("packs.search.config").telescope_dap_setup()
  end,

  config = function()
    require("packs.search.config").telescope_dap()
  end
}

return search
