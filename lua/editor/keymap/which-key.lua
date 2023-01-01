local char = require("utf8").char
local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,
    registers = true,
  },
  icons = {
    breadcrumb = char(0xf641),
    separator = char(0xf63d),
    group = "",
  },
  window = {
    border = "rounded",
  },
  layout = {
    height = {
      min = 4,
      max = 25,
    },
    width = {
      min = 20,
      max = 50,
    },
    key_labels = {
      ["<leader>"] = "L",
      ["<localleader>"] = "LL",
      ["<Space>"] = "SPC",
      ["<Tab>"] = "TAB",
      ["<S-Tab>"] = "S-TAB",
    },
    hidden = {
      "<silent>",
      "<cmd>",
      "<Cmd>",
      "call",
      "lua",
      "^:",
      "^ ",
    },
    show_help = true,
    triggers = {
      "<leader>",
      "z",
      "<localleader>",
    },
  },
})

local options = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
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
  ["c"] = {
    name = "+Containers",

    ["c"] = {
      name = "+Compose",
    },

    ["C"] = {
      name = "+devcontainer.json",
    },
  },
  ["d"] = {
    name = "+DAP",
  },
  ["g"] = {
    name = "+Git",

    ["c"] = {
      name = "+Conflict",
    },
  },
  ["l"] = {
    name = "+LSP",

    ["c"] = {
      name = "+Calls",
    },

    ["w"] = {
      name = "+Workspace",
    },

    ["s"] = {
      name = "+Symbol",
    },
  },
  ["p"] = {
    name = "+Plugins",
  },
  ["s"] = {
    name = "+Search",

    ["t"] = {
      name = "+Tasks",
    },
  },
  ["S"] = {
    name = "+Session",
  },
}

local mappings_local = {}

local options_local = {
  mode = "n",
  prefix = "<localleader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}

wk.register(mappings, options)
