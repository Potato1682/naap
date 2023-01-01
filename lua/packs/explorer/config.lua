local M = {}

local constants = require("core.constants")

function M.neotree_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>e", function()
    vim.cmd("Neotree toggle position=float")
  end, "Open Explorer")

  local group = vim.api.nvim_create_augroup("hijack_netrw", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "*",
    callback = function()
      local dir = vim.api.nvim_buf_get_name(0)
      local stat = vim.loop.fs_stat(dir)

      if not stat or stat.type ~= "directory" then
        return
      end

      _G.PLoader("neo-tree.nvim")
    end,
  })
end

function M.neotree()
  local char = require("utf8").char

  require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",

    event_handlers = {
      {
        event = "file_renamed",

        handler = function(args)
          local client = require("utils.lsp").find_client("tsserver")

          if not client then
            return
          end

          local source, target = args.source, args.destination
          local ok = client.request("workspace/executeCommand", {
            command = "_typescript.applyRenameFile",
            arguments = {
              {
                sourceUri = vim.uri_from_fname(source),
                targetUri = vim.uri_from_fname(target),
              },
            },
          })

          if not ok then
            vim.notify("Failed to refactor rename: tsserver request failed", vim.log.levels.WARN, { title = "lsp" })
          end
        end,
      },
    },

    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      icon = {
        folder_closed = char(0xf07b),
        folder_open = char(0xf114),
        folder_empty = char(0xf115),
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = "✖", -- this can only be used in the git_status source
          renamed = "", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },

    window = {
      mappings = {
        ["h"] = function(state)
          local node = state.tree:get_node()

          if node and node.type == "directory" and node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        ["l"] = function(state)
          local node = state.tree:get_node()

          if node and node.type == "directory" then
            if not node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            elseif node:has_children() then
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        end,
        ["<Tab>"] = function(state)
          local node = state.tree:get_node()

          if node and require("neo-tree.utils").is_expandable(node) then
            state.commands["toggle_node"](state)
          else
            state.commands["open"](state)

            vim.cmd("Neotree reveal")
          end
        end,
      },
    },

    filesystem = {
      group_empty_dirs = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,

      window = {
        popup = {
          position = {
            col = "100%",
            row = "2",
          },
          size = function(state)
            local root_name = vim.fn.fnamemodify(state.path, ":~")
            local root_len = string.len(root_name) + 4

            return {
              width = math.max(root_len, 50),
              height = vim.opt_local.lines:get() - 6,
            }
          end,
        },
        mappings = {
          ["<BS>"] = function(state)
            local node = state.tree:get_node()

            if node and node.path == vim.loop.cwd() then
              require("neo-tree.sources.filesystem.commands").navigate_up(state)
            else
              require("neo-tree.sources.common.commands").close_node(state)
            end
          end,
          ["i"] = "run_command",
          ["O"] = "system_open",
        },
      },

      commands = {
        run_command = function(state)
          local node = state.tree:get_node()

          if not node then
            return
          end

          local path = node:get_id()

          vim.api.nvim_input(": " .. path .. "<Home>")
        end,
        system_open = function(state)
          if not node then
            return
          end

          local node = state.tree:get_node()

          local path = node:get_id()

          if constants.is_linux then
            vim.api.nvim_command("silent !xdg-open " .. path)
            -- TODO
            -- elseif constants.is_macos then
            --   vim.api.nvim_command("silent !open -g " .. path)
          end
        end,
      },
    },
  })
end

return M
