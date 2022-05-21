local M = {}

function M.devcontainer_setup()
  vim.keymap.set("n", "<leader>cCo", function()
    require("devcontainer.commands").open_nearest_devcontainer_config()
  end, {
    desc = "Open devcontainer.json"
  })

  vim.keymap.set("n", "<leader>cCe", function()
    require("devcontainer.commands").edit_devcontainer_config()
  end, {
    desc = "Edit devcontainer.json"
  })

  vim.keymap.set("n", "<leader>ccu", function()
    require("devcontainer.commands").compose_up()
  end, {
    desc = "Compose Up"
  })

  vim.keymap.set("n", "<leader>ccd", function()
    require("devcontainer.commands").compose_down()
  end, {
    desc = "Compose Down"
  })

  vim.keymap.set("n", "<leader>ccr", function()
    require("devcontainer.commands").compose_rm()
  end, {
    desc = "Remove Compose"
  })

  vim.keymap.set("n", "<leader>cb", function()
    require("devcontainer.commands").docker_build_run_and_attach()
  end, {
    desc = "Build, Run, and Attach to Image"
  })

  vim.keymap.set("n", "<leader>cs", function()
    require("devcontainer.commands").stop_auto()
  end, {
    desc = "Stop"
  })

  vim.keymap.set("n", "<leader>cr", function()
    require("devcontainer.commands").remove_all()
  end, {
    desc = "Remove All Images"
  })
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
