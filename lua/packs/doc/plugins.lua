local doc = {}

doc["danymat/neogen"] = {
  module = "neogen",

  config = function()
    require("packs.doc.config").neogen()
  end
}

return doc
