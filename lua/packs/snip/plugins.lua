local snip = {}

snip["L3MON4D3/LuaSnip"] = {
  requires = {
    "rafamadriz/friendly-snippets",

    event = "InsertEnter"
  },

  event = "InsertEnter",

  config = function()
    require("packs.snip.config").luasnip()
  end
}

return snip
