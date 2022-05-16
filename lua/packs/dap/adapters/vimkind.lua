local dap = require("dap")

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      local host = vim.fn.input("Host [127.0.0.1]: ")

      if host ~= "" then
        return host
      end

      return "127.0.0.1"
    end,
    port = function()
      local port = tonumber(vim.fn.input("Port: "))

      assert(port, "Please provide a port number")

      return port
    end
  }
}

dap.adapters.nlua = function(callback, config)
  callback {
    type = "server",
    host = config.host,
    port = config.port
  }
end

vim.api.nvim_create_user_command("DebugNaaPLaunch", function()
  require("osv").launch()
end, {})

vim.api.nvim_create_user_command("DebugNaaPRunThis", function()
  require("osv").run_this()
end, {})

