local doc = {}

doc["danymat/neogen"] = {
  module = "neogen",

  setup = function()
    require("packs.doc.config").neogen_setup()
  end,

  config = function()
    require("packs.doc.config").neogen()
  end,
}

return doc
