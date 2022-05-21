local M = {}

function M.remember()
  require("remember").setup {}
end

function M.other_setup()
  vim.keymap.set("n", "soo", function()
    require("other-nvim").open()
  end, {
    desc = "Open Other File"
  })
  vim.keymap.set("n", "sos", function()
    require("other-nvim").openSplit()
  end, {
    desc = "Open Other File with Split"
  })
  vim.keymap.set("n", "sov", function()
    require("other-nvim").openVSplit()
  end, {
    desc = "Open Other File with VSplit"
  })
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

function M.auto_session()
  require("auto-session").setup {
    auto_session_enable_last_session = true,
    auto_session_use_git_branch = true,
    auto_save_enabled = O.sessions.auto_save,
    auto_restore_enabled = O.sessions.auto_load
  }
end

return M
