local char = require("utf8").char

local conditions = {
  check_git_workspace = function()
    return require("core.git").check_git_workspace()
  end,
  hide_in_width = function()
    return vim.api.nvim_win_get_width(0) / 2 >= 50
  end
}

local colors = {
  yellow = "#e5c07b",
  orange = "#e6a370",
  vivid_orange = "#ff8800",
  green = "#98c379",
  magenta = "#c678dd",
  purple = "#a278dd",
  grey = "#abb2bf",
  dark_grey = "#70757d",
  blue = "#61afef",
  red = "#e06c75",
}

local config = {
  options = {
    --[[
    component_separators = {
      left = char(0xe0b9),
      right = char(0xe0bb)
    },
    ]]
    component_separators = {
      left = "",
      right = ""
    },
    section_separators = {
      left = char(0xe0b8),
      right = char(0xe0ba)
    },
    globalstatus = true
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

  -- Inserts a component in lualine_c at left section
local ins_left = function(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local ins_right = function(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  "mode",
  fmt = function(mode)
    return mode:sub(1, 1)
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.blue,
      i = colors.green,
      v = colors.purple,
      [''] = colors.purple,
      V = colors.purple,
      c = colors.magenta,
      no = colors.blue,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.green,
      R = colors.red,
      Rv = colors.red,
      cv = colors.red,
      ce = colors.red,
      ['r?'] = colors.red,
      ['!'] = colors.blue,
      t = colors.blue,
    }

    return { fg = "bg", bg = mode_color[vim.fn.mode()] }
  end,
  padding = { left = 2, right = 2 }
}

-- devcontainers icon
ins_left {
  function()
    return char(0xf636)
  end,
  cond = function()
    return not not vim.g.currentContainer
  end,
  color = { fg = colors.blue },
  padding = { left = 2 }
}

-- devcontainers
ins_left {
  function()
    return vim.g.currentContainer
  end,
  cond = function()
    return not not vim.g.currentContainer
  end,
  padding = { left = 1, right = 0 }
}

-- current working directory icon
ins_left {
  function()
    return char(0xf74a)
  end,
  color = { fg = colors.blue },
  padding = { left = 2, right = 1 }
}

-- current working directory
ins_left {
  function()
    return vim.fn.fnamemodify(vim.loop.cwd(), ":t")
  end
}

-- git branch icon
ins_left {
  function()
    return char(0xfb2b)
  end,
  color = { fg = colors.orange },
  cond = conditions.check_git_workspace,
  padding = { left = 1, right = 0 }
}

-- git branch
ins_left {
  "branch",
  icon = "",
  padding = { left = 0 }
}

-- diff
ins_left {
  "diff",
  symbols = {
    added = char(0xf457) .. " ",
    modified = char(0xf459) .. " ",
    removed = char(0xf458) .. " "
  },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red }
  },
  cond = conditions.hide_in_width
}

-- breadcrumb
ins_left {
  function()
    local ok, gps = pcall(require, "nvim-gps")

    if not ok then
      return ""
    end

    return gps.get_location()
  end,
  cond = function()
    local ok, gps = pcall(require, "nvim-gps")

    if not ok then
      return false
    end

    return gps.is_available()
  end,
  color = { fg = colors.blue }
}

-- lsp diagnostics
ins_right {
  "diagnostics",
  sources = {
    "nvim_diagnostic"
  },
  symbols = {
    error = char(0xf659) .. " ",
    warn = char(0xf529) .. " ",
    info = char(0xf7fc) .. " "
  },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.blue }
  }
}

-- lsp no any diagnostics
ins_right {
  function()
    return char(0xf633)
  end,
  cond = function()
    return vim.tbl_isempty(vim.diagnostic.get(0))
  end,
  color = { fg = colors.green }
}

-- lsp servers
ins_right {
  function()
    local clients = {}

    for _, client in ipairs(vim.lsp.buf_get_clients()) do
      if client.name == "pyright" then
        if CURRENT_VENV ~= nil then
          local venv_name = client.config.settings.python.venv_name or "venv"

          if CURRENT_VENV ~= "venv" then
            venv_name = CURRENT_VENV
          end

          clients[#clients + 1] = client.name .. "(" .. venv_name .. ")"
        end
      else
        clients[#clients + 1] = client.name
      end
    end

    if vim.tbl_isempty(clients) then
      return "No Active LSP"
    end

    return table.concat(clients, ", ")
  end,
  icon = char(0xf085) .. " ",
  color = { fg = colors.blue }
}

-- line column icon
ins_right {
  function()
    return " "
  end,
  color = { fg = colors.green }
}

-- line column
ins_right {
  "location",
  padding = { right = 1 }
}

-- indent size
ins_right {
  function()
    if vim.opt_local.expandtab:get() then
      return vim.opt_local.tabstop:get() .. " Spaces"
    else
      return vim.opt_local.shiftwidth:get() .. " Tab Width"
    end
  end,
  condition = conditions.hide_in_width,
  color = function()
    local color = vim.opt_local.expandtab:get() and colors.blue or colors.magenta

    return { fg = color }
  end
}

require("lualine").setup(config)

