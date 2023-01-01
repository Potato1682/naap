local M = {}

function M.remember()
  require("remember").setup({})
end

function M.other_setup()
  local keymap = require("utils.keymap").omit("append", "n", "so")

  keymap("o", function()
    require("other-nvim").open()
  end, "Open Other File")
  keymap("s", function()
    require("other-nvim").openSplit()
  end, "Open Other File with Split")
  keymap("v", function()
    require("other-nvim").openVSplit()
  end, "Open Other File with VSplit")
end

function M.other()
  require("other-nvim").setup({
    mappings = {
      "livewire",
      "angular",
      "laravel",
      {
        pattern = "lua/packs/(.*)/plugins.lua",
        target = "lua/packs/%1/config.lua",
      },
      {
        pattern = "lua/packs/(.*)/config.lua",
        target = "lua/packs/%1/plugins.lua",
      },
    },
  })
end

return M
