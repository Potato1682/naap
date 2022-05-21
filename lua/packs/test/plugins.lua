local test = {}

test["klen/nvim-test"] = {
  cmd = {
    "TestSuite",
    "TestFile",
    "TestEdit",
    "TestNearest",
    "TestLast",
    "TestVisit",
    "TestInfo"
  },

  config = function()
    require("packs.test.config").test()
  end
}

return test
