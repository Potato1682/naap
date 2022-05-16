local M = {}

function M.dap_setup()
  local set = function(lhs, rhs, desc)
    vim.keymap.set("n", "<leader>d" .. lhs, rhs, {
      desc = desc
    })
  end

  set("b", function()
    require("dap").toggle_breakpoint()
  end, "Toggle Breakpoint")

  -- TODO B: Telescope breakpoints

  set("c", function()
    require("dap").run_to_cursor()
  end, "Run To Cursor")

  set("d", function()
    require("dap").continue()
  end, "Continue")

  set("e", function()
    require("dapui").eval()
  end, "Eval Current Expression")

  set("E", function()
    require("dapui").float_element()
  end, "Current Elements")

  set("i", function()
    require("dap").step_into()
  end, "Step Into")

  set("o", function()
    require("dap").step_over()
  end, "Step Over")

  set("O", function()
    require("dap").step_out()
  end, "Step Out")

  set("r", function()
    require("dap.repl").open()
  end, "Open REPL")
end

function M.dap()
  local dap = require("dap")

  dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    require("dapui").close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    require("dapui").close()
  end

  vim.fn.sign_define("DapBreakpoint", {
    tect = "🛑",
    texthl = "",
    linehl = "",
    numhl = ""
  })

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

    notif_data.notification.spinner = 1,

        progress.update_spinner("dap", body.progressId)
  end

  dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
    local notif_data = progress.get_notif_data("dap", body.progressId)

    notif_data.notification = vim.notify(progress.format_message(body.message, body.percentage), "info", {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  end

  dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
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
