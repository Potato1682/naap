local M = {}

function M.telescope_setup()
  vim.keymap.set("n", "<leader>f", function()
    require("telescope.builtin").find_files()
  end, {
    desc = "Find file"
  })

  vim.keymap.set("n", "<leader>sC", function()
    require("telescope.builtin").colorscheme()
  end, {
    desc = "Colorscheme"
  })

  vim.keymap.set("n", "<leader>ga", function()
    require("telescope.builtin").git_stash()
  end, {
    desc = "Stashes"
  })

  vim.keymap.set("n", "<leader>gb", function()
    require("telescope.builtin").git_branches()
  end, {
    desc = "Branches"
  })

  vim.keymap.set("n", "<leader>gc", function()
    require("telescope.builtin").git_commits()
  end, {
    desc = "Commits"
  })
end

function M.telescope()
  local char = require("utf8").char
  local actions = require("telescope.actions")
  local actions_layout = require("telescope.actions.layout")
  local actions_util = require("utils.telescope.actions")

  require("telescope").setup {
    defaults = {
      winblend = 10,
      prompt_prefix = char(0xf002) .. " ",
      selection_caret = char(0x276f) .. " ",
      path_display = {
        shorten = {
          len = 1,
          exclude = { 3, 4, -1 }
        }
      },
      dynamic_preview_title = true,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-o>"] = actions.select_vertical,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions_layout.toggle_preview,
          ["<C-y>"] = actions_util.set_prompt_to_entry_value,
          ["<C-d>"] = actions.preview_scrolling_up,
          ["<C-f>"] = actions.preview_scrolling_down,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-u>"] = actions.cycle_history_prev,
          ["<Esc>"] = actions.close,
          ["<cr>"] = actions.select_default + actions.center
        }
      }
    },
    pickers = {
      find_files = {
        theme = "dropdown"
      }
    },
    extensions = {
      -- Sorter
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case"
      },
    }
  }

  require("utils.telescope").load_registered_extensions()
end

function M.telescope_fzf_native()
  require("utils.telescope").register_extension("fzf")
end

function M.telescope_media_files_setup()
  vim.keymap.set("n", "<leader>F", function()
    require("telescope").extensions.media_files.media_files()
  end, {
    desc = "Find file"
  })
end

function M.telescope_media_files()
  require("utils.telescope").register_extension("media_files")
end

function M.telescope_dap_setup()
  vim.keymap.set("n", "<leader>sb", function()
    require("telescope").extensions.dap.list_breakpoints {}
  end, {
    desc = "Breakpoints"
  })

  vim.keymap.set("n", "<leader>dC", function()
    require("telescope").extensions.dap.configurations {}
  end, {
    desc = "Configurations"
  })

  vim.keymap.set("n", "<leader>dv", function()
    require("telescope").extensions.dap.variables {}
  end, {
    desc = "Variables"
  })

  vim.keymap.set("n", "<leader>df", function()
    require("telescope").extensions.dap.frames {}
  end, {
    desc = "Frames"
  })
end

function M.telescope_dap()
  require("utils.telescope").register_extension("dap")
end

return M
