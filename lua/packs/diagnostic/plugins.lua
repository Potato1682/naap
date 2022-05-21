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

return diagnostic
