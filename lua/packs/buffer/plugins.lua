local buffer = {}

buffer["famiu/bufdelete.nvim"] = {
  module = "bufdelete",

  setup = function()
    require("packs.buffer.config").bufdelete_setup()
  end,
}

buffer["ghillb/cybu.nvim"] = {
  module = "cybu",

  setup = function()
    require("packs.buffer.config").cybu_setup()
  end,

  config = function()
    require("packs.buffer.config").cybu()
  end,
}

buffer["tiagovla/scope.nvim"] = {
  event = {
    "BufWinEnter",
  },

  config = function()
    require("scope").setup()
  end,
}

return buffer
