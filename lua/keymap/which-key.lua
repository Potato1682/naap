local char = require("utf8").char
local wk = require("which-key")

wk.setup {
  plugins = {
    marks = true,
    registers = true
  },
  icons = {
    breadcrumb = char(0xf641),
    separator = char(0xf63d),
    group = ""
  },
  window = {
    border = "rounded",
  },
  layout = {
    height = {
      min = 4,
      max = 25
    },
    width = {
      min = 20,
      max = 50
    },
    key_labels = {
      ["<leader>"] = "L",
      ["<localleader>"] = "LL",
      ["<Space>"] = "SPC",
      ["<Tab>"] = "TAB",
      ["<S-Tab>"] = "S-TAB"
    },
    hidden = {
      "<silent>",
      "<cmd>",
      "<Cmd>",
      "call",
      "lua",
      "^:",
      "^ "
    },
    show_help = true,
    triggers = {
      "<leader>",
      "z",
      "<localleader>"
    }
  }
}

local options = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false
}

local b_goto = function(bufnr)
  local ok, bufferline = pcall(require, "bufferline")

  if not ok then
    vim.cmd("b " .. bufnr)

    return
  end

  bufferline.go_to_buffer(bufnr)
end

local mappings = {
  ["1"] = {
    function()
      b_goto(1)
    end,
    "Buffer #1"
  },
  ["2"] = {
    function()
      b_goto(2)
    end,
    "Buffer #2"
  },
  ["3"] = {
    function()
      b_goto(3)
    end,
    "Buffer #3"
  },
  ["4"] = {
    function()
      b_goto(4)
    end,
    "Buffer #4"
  },
  ["5"] = {
    function()
      b_goto(5)
    end,
    "Buffer #5"
  },
  ["6"] = {
    function()
      b_goto(6)
    end,
    "Buffer #6"
  },
  ["7"] = {
    function()
      b_goto(7)
    end,
    "Buffer #7"
  },
  ["8"] = {
    function()
      b_goto(8)
    end,
    "Buffer #8"
  },
  ["9"] = {
    function()
      b_goto(9)
    end,
    "Buffer #9"
  },
  ["d"] = {
    name = "+DAP",

    ["b"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "Toggle Breakpoint"
    },
    -- TODO B: Telescope breakpoints
    ["c"] = {
      function()
        require("dap").run_to_cursor()
      end,
      "Run To Cursor"
    },
    ["d"] = {
      function()
        require("dap").continue()
      end,
      "Continue"
    },
    ["e"] = {
      function()
        require("dapui").eval()
      end,
      "Eval Current Expression"
    },
    ["E"] = {
      function()
        require("dapui").float_element()
      end,
      "Current Elements"
    },
    ["i"] = {
      function()
        require("dap").step_into()
      end,
      "Step Into"
    },
    ["o"] = {
      function()
        require("dap").step_over()
      end,
      "Step Over"
    },
    ["O"] = {
      function()
        require("dap").step_out()
      end,
      "Step Out"
    },
    ["r"] = {
      function()
        require("dap.repl").open()
      end,
      "Open REPL"
    }
  },
  ["l"] = {
    name = "+LSP",

    ["c"] = {
      name = "+Calls"
    },

    ["w"] = {
      name = "+Workspace"
    },

    ["s"] = {
      name = "+Symbol"
    }
  },
  ["h"] = "nohlsearch",
  ["q"] = {
    function()
      require("bufdelete").bufdelete(0, false)
    end,
    "Close buffer"
  }
}

local mappings_local = {
  ["d"] = {
     function()
       require("neogen").generate()
     end,
    "Generate document"
  },
  ["j"] = "Join lines"
}

local options_local = {
  mode = "n",
  prefix = "<localleader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false
}

wk.register(mappings, options)
wk.register(mappings_local, options_local)
