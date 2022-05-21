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

function M.persisted()
  require("persisted").setup {
    autosave = O.sessions.autosave,
    autoload = O.sessions.autoload,
    allowed_dirs = O.sessions.allowed_dirs,
    ignored_dirs = O.sessions.ignored_dirs,
    use_git_branch = true
  }

  vim.keymap.set("n", "<leader>sS", function()
    require("telescope").extensions.persisted.persisted {}
  end, {
    desc = "Sessions"
  })

  vim.keymap.set("n", "<leader>SS", function()
    require("persisted").toggle()
  end, {
    desc = "Toggle Session"
  })

  vim.keymap.set("n", "<leader>Ss", function()
    require("persisted").save()
  end, {
    desc = "Save Session"
  })

  vim.keymap.set("n", "<leader>Sl", function()
    vim.ui.input({
      prompt = "Session name",
      completion = function()
        return require("persisted").list()
      end
    }, function(input)
      if not input then
        return
      end

      require("persisted").load(input)
    end)
  end, {
    desc = "Load Session"
  })

  vim.keymap.set("n", "<leader>Sd", function()
    require("persisted").delete()
  end, {
    desc = "Delete Session"
  })

  require("utils.telescope").register_extension("persisted")
end

return M
