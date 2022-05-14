local M = {}

function M.remember()
  require("remember").setup {}
end

function M.other_setup()
  vim.keymap.set("n", "soo", function()
    require("other-nvim").open()
  end)
  vim.keymap.set("n", "sos", function()
    require("other-nvim").openSplit()
  end)
  vim.keymap.set("n", "sov", function()
    require("other-nvim").openVSplit()
  end)
end

function M.other()
  require("other-nvim").setup {
    mappings = {
      "livewire",
      "angular",
      "laravel",
      {
        pattern = "lua/packs/(.*)/plugins.lua",
        target = "lua/packs/%1/config.lua"
      },
      {
        pattern = "lua/packs/(.*)/config.lua",
        target = "lua/packs/%1/plugins.lua"
      }
    }
  }
end

function M.persisted()
  require("persisted").setup {
    autosave = O.sessions.autosave,
    autoload = O.sessions.autoload,
    allowed_dirs = O.sessions.allowed_dirs,
    ignored_dirs = O.sessions.ignored_dirs,
    use_git_branch = true
  }
end

return M
