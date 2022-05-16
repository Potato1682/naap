local buffer = {}

buffer["famiu/bufdelete.nvim"] = {
  module = "bufdelete",

  setup = function()
    require("packs.buffer.config").bufdelete_setup()
  end
}

return buffer
