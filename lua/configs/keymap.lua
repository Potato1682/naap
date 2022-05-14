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
  ["h"] = "nohlsearch",
  ["q"] = {
    function()
      require("bufdelete").bufdelete()
    end,
    "Close buffer"
  },
  ["l"] = {
    name = "+LSP",

    ["a"] = {
      "<cmd>CodeActionMenu<cr>",
      "Code Action"
    },
    ["f"] = {
      "<cmd>Format<cr>",
      "Format"
    },
    ["I"] = {
      "<cmd>LspInfo<cr>",
      "Information"
    }
  }
}

local mappings_local = {
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
