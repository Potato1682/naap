local test = {}

test["nvim-neotest/neotest"] = {
  requires = {
    {
      "nvim-neotest/neotest-vim-test",

      requires = {
        { "vim-test/vim-test", opt = true },
      },

      wants = {
        "vim-test",
      },

      module = "neotest-vim-test",
    },
  },

  module = "neotest",

  config = function()
    require("packs.test.config").test()
  end,
}

return test
