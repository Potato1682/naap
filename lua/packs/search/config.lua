local M = {}

function M.telescope_setup()
  local keymap = require("utils.keymap.presets").leader("n", "")

  keymap("f", function()
    require("telescope.builtin").find_files()
  end, "Find file")

  keymap("sC", function()
    require("telescope.builtin").colorscheme()
  end, "Colorscheme")

  keymap("ga", function()
    require("telescope.builtin").git_stash()
  end, "Stashes")

  keymap("gb", function()
    require("telescope.builtin").git_branches()
  end, "Branches")

  keymap("gc", function()
    require("telescope.builtin").git_commits()
  end, "Commits")
end

function M.telescope()
  local char = require("utf8").char
  local actions = require("telescope.actions")
  local actions_layout = require("telescope.actions.layout")
  local actions_util = require("utils.telescope.actions")

  require("telescope").setup({
    defaults = {
      winblend = 10,
      prompt_prefix = char(0xf002) .. " ",
      selection_caret = char(0x276f) .. " ",
      path_display = {
        shorten = {
          len = 1,
          exclude = { 3, 4, -1 },
        },
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
          ["<cr>"] = actions.select_default + actions.center,
        },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
      },
    },
    extensions = {
      -- Sorter
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  require("utils.telescope").load_registered_extensions()
end

function M.telescope_fzf_native()
  require("utils.telescope").register_extension("fzf")
end

function M.telescope_media_files_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>F", function()
    require("telescope").extensions.media_files.media_files()
  end, "Find file")
end

function M.telescope_media_files()
  require("utils.telescope").register_extension("media_files")
end

function M.telescope_dap_setup()
  local keymap = require("utils.keymap.presets").leader("n", "")

  keymap("sb", function()
    require("telescope").extensions.dap.list_breakpoints({})
  end, "Breakpoints")

  keymap("dC", function()
    require("telescope").extensions.dap.configurations({})
  end, "Configurations")

  keymap("dv", function()
    require("telescope").extensions.dap.variables({})
  end, "Variables")

  keymap("df", function()
    require("telescope").extensions.dap.frames({})
  end, "Frames")
end

function M.telescope_dap()
  require("utils.telescope").register_extension("dap")
end

return M
