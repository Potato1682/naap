local diagnostic = {}

diagnostic["Kasama/nvim-custom-diagnostic-highlight"] = {
  event = {
    "BufNewFile",
    "BufReadPost",
  },

  config = function()
    require("packs.diagnostic.config").highlight()
  end,
}

return diagnostic
