local M = {}

function M.devcontainer_setup()
  local keymap = require("utils.keymap").omit("append", "n", "<leader>c")

  keymap("Co", function()
    require("devcontainer.commands").open_nearest_devcontainer_config()
  end, "Open devcontainer.json")

  keymap("Ce", function()
    require("devcontainer.commands").edit_devcontainer_config()
  end, "Edit devcontainer.json")

  keymap("cu", function()
    require("devcontainer.commands").compose_up()
  end, "Compose Up")

  keymap("cd", function()
    require("devcontainer.commands").compose_down()
  end, "Compose Down")

  keymap("cr", function()
    require("devcontainer.commands").compose_rm()
  end, "Remove Compose")

  keymap("b", function()
    require("devcontainer.commands").docker_build_run_and_attach()
  end, "Build, Run, and Attach to Image")

  keymap("s", function()
    require("devcontainer.commands").stop_auto()
  end, "Stop")

  keymap("r", function()
    require("devcontainer.commands").remove_all()
  end, "Remove All Images")
end

function M.devcontainer()
  require("devcontainer").setup {
    autocommands = {
      clean = true,
      update = true
    },
    attach_mounts = {
      always = true,
      neovim_config = {
        enabled = true,
        options = {}
      },
      neovim_data = {
        enabled = true
      },
      neovim_state = {
        enabled = true
      }
    },
    terminal_handler = function(command)
      local output = ""
      local notification

      local notify = function(msg, level)
        notification = vim.notify(msg, level, {
          title = "devcontainer",
          replace = notification
        })
      end

      local on_data = function(_, data)
        output = output .. table.concat(data, "\n")

        notify(output, "info")
      end

      vim.fn.jobstart(command, {
        on_stdout = on_data,
        on_stderr = on_data,
        on_exit = function(_, code)
          if #output == 0 then
            notify("No output of command, exit code: " .. code, "warn")
          end
        end
      })
    end
  }
end

return M
