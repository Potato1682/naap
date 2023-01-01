local snip = {}

snip["L3MON4D3/LuaSnip"] = {
  requires = {
    { "rafamadriz/friendly-snippets", opt = true }
  },

  wants = {
    "friendly-snippets"
  },

  module = "luasnip",

  config = function()
    require("packs.snip.config").luasnip()
  end
}

return snip
