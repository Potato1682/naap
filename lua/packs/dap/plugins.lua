local dap = {}

dap["mfussenegger/nvim-dap"] = {
  module = "dap",

  config = function()
    require("packs.dap.config").dap()
  end
}

dap["rcarriga/nvim-dap-ui"] = {
  module = "dapui",

  config = function()
    require("packs.dap.config").ui()
  end
}

dap["theHamsta/nvim-dap-virtual-text"] = {
  after = "nvim-dap",

  config = function()
    require("packs.dap.config").virtual_text()
  end
}

-- Adapters

-- TODO Pocco81/dap-buddy.nvim

dap["jbyuki/one-small-step-for-vimkind"] = {
  module = "osv"
}

return dap
