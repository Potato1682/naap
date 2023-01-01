local search = {}

search["nvim-telescope/telescope.nvim"] = {
  module = "telescope",

  setup = function()
    require("packs.search.config").telescope_setup()
  end,

  config = function()
    require("packs.search.config").telescope()
  end,
}

-- Sorter
search["nvim-telescope/telescope-fzf-native.nvim"] = {
  module = "fzf_lib",

  run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",

  config = function()
    require("packs.search.config").telescope_fzf_native()
  end,
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
  end,
}

-- Pickers
search["nvim-telescope/telescope-dap.nvim"] = {
  after = "telescope.nvim",

  setup = function()
    require("packs.search.config").telescope_dap_setup()
  end,

  config = function()
    require("packs.search.config").telescope_dap()
  end,
}

return search
