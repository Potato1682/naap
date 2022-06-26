local diagnostic = {}

diagnostic["Mofiqul/trld.nvim"] = {
  event = {
    "BufNewFile",
    "BufReadPost"
  },

  config = function()
    require("packs.diagnostic.config").trld()
  end
}

diagnostic["Kasama/nvim-custom-diagnostic-highlight"] = {
  event = {
    "BufNewFile",
    "BufReadPost"
  },

  config = function()
    require("packs.diagnostic.config").highlight()
  end
}

return diagnostic
