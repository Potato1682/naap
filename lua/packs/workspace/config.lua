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

function M.persisted()
  require("persisted").setup({
    autosave = O.sessions.autosave,
    autoload = O.sessions.autoload,
    allowed_dirs = O.sessions.allowed_dirs,
    ignored_dirs = O.sessions.ignored_dirs,
    use_git_branch = true,
  })

  local keymap_search = require("utils.keymap.presets").leader("n", "s")
  local keymap = require("utils.keymap.presets").leader("n", "S")

  keymap_search("S", function()
    require("telescope").extensions.persisted.persisted({})
  end, "Sessions")

  keymap("S", function()
    require("persisted").toggle()
  end, "Toggle Session")

  keymap("s", function()
    require("persisted").save()
  end, "Save Session")

  keymap("l", function()
    vim.ui.input({
      prompt = "Session name",
      completion = function()
        return require("persisted").list()
      end,
    }, function(input)
      if not input then
        return
      end

      require("persisted").load(input)
    end)
  end, "Load Session")

  keymap("d", function()
    require("persisted").delete()
  end, "Delete Session")

  require("utils.telescope").register_extension("persisted")
end

return M
