local M = {}

function M.dap_setup()
  local keymap = require("utils.keymap.presets").leader("n", "d")

  keymap("bb", function()
    require("dap").toggle_breakpoint()
  end, "Toggle Breakpoint")

  keymap("bc", function()
    vim.ui.input("Breakpoint condition", function(input)
      if not input then
        return
      end

      require("dap").set_breakpoint(input)
    end)
  end, "Conditional Breakpoint")

  keymap("bl", function()
    vim.ui.input("Log point message", function(input)
      if not input then
        return
      end

      require("dap").set_breakpoint(nil, nil, input)
    end)
  end, "Log Breakpoint")

  keymap("c", function()
    require("dap").run_to_cursor()
  end, "Run To Cursor")

  keymap("d", function()
    require("dap").continue()
  end, "Continue")

  keymap("e", function()
    require("dapui").eval()
  end, "Eval Current Expression")

  keymap("E", function()
    require("dapui").float_element()
  end, "Current Elements")

  keymap("i", function()
    require("dap").step_into()
  end, "Step Into")

  keymap("o", function()
    require("dap").step_over()
  end, "Step Over")

  keymap("O", function()
    require("dap").step_out()
  end, "Step Out")

  keymap("r", function()
    require("dap.repl").open()
  end, "Open REPL")
end

function M.dap()
  local char = require("utf8").char
  local dap = require("dap")

  vim.fn.sign_define("DapBreakpoint", {
    text = char(0xf62e) .. " ",
    texthl = "Error",
    linehl = "",
    numhl = ""
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = char(0xf62e) .. " ",
    texthl = "WarningMsg",
    linehl = "",
    numhl = ""
  })

  vim.fn.sign_define("DapLogPoint", {
    text = char(0xf62e) .. " ",
    texthl = "DiagnosticSignInfo",
    linehl = "",
    numhl = ""
  })

  vim.fn.sign_define("DapStopped", {
    text = char(0x2588) .. char(0xe0b0),
    texthl = "WarningMsg",
    linehl = "",
    numhl = ""
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    require("dapui").close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    require("dapui").close()
  end

  require("dap.ext.vscode").load_launchjs()

  local progress = require("utils.progress")

  dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
    local notif_data = progress.get_notif_data("dap", body.progressId)
    local message = progress.format_message(body.message, body.percentage)

    notif_data.notification = vim.notify(message, "info", {
      title = progress.format_title(body.title, session.config.type),
      icon = progress.spinner_frames[1],
      timeout = false,
      hide_from_history = false,
    })

    notif_data.notification.spinner = 1

    progress.update_spinner("dap", body.progressId)
  end

  dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(_, body)
    local notif_data = progress.get_notif_data("dap", body.progressId)

    notif_data.notification = vim.notify(progress.format_message(body.message, body.percentage), "info", {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  end

  dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(_, body)
    local notif_data = progress.client_notifs["dap"][body.progressId]

    notif_data.notification = vim.notify(body.message and progress.format_message(body.message) or "Complete", "info", {
      icon = "",
      replace = notif_data.notification,
      timeout = 3000
    })

    notif_data.spinner = nil
  end

  require("packs.dap.adapters.vimkind")
end

function M.ui_setup()
end

function M.ui()
  require("dapui").setup()
end

function M.virtual_text()
  require("nvim-dap-virtual-text").setup {
    commented = O.debug.virtual_text.commented
  }
end

return M
