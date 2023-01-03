local char = require("utf8").char

local conditions = {
  check_git_workspace = function()
    return require("utils.git").check_git_workspace()
  end,
  hide_in_width = function()
    return vim.api.nvim_win_get_width(0) / 2 >= 50
  end,
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

local refreshable_color = function(fg, bg)
  return function()
    local raw_bg = require("utils.highlight").get_color_code_from_hl_name("StatusLine", "guibg")

    if raw_bg and not bg then
      bg = "#" .. raw_bg
    end

    fg = fg or colors.grey

    return { fg = fg, bg = bg }
  end
end

local config = {
  options = {
    theme = "catppuccin",
    component_separators = {
      left = "",
      right = "",
    },
    section_separators = {
      left = "",
      right = "",
    },
    globalstatus = true,
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_d = {},
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
  extensions = {
    require("lualine.extensions.quickfix"),
  },
}

-- Inserts a component in lualine_c at left section
local ins_left_a = function(component)
  table.insert(config.sections.lualine_a, component)
end

local ins_left = function(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local ins_right = function(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left_a({
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
      [""] = colors.purple,
      V = colors.purple,
      c = colors.magenta,
      no = colors.blue,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.green,
      R = colors.red,
      Rv = colors.red,
      cv = colors.red,
      ce = colors.red,
      ["r?"] = colors.red,
      ["!"] = colors.blue,
      t = colors.blue,
    }

    return { fg = "#1e2030", bg = mode_color[vim.fn.mode()] }
  end,
  padding = { left = 2, right = 2 },
})

-- TODO migrate to nvim-dev-container
-- devcontainers icon
ins_left({
  function()
    return char(0xf636)
  end,
  cond = function()
    return not not vim.g.currentContainer
  end,
  color = refreshable_color(colors.blue),
  padding = { left = 2 },
})

-- devcontainers
ins_left({
  function()
    return vim.g.currentContainer
  end,
  cond = function()
    return not not vim.g.currentContainer
  end,
  padding = { left = 1, right = 0 },
})

-- current working directory icon
ins_left({
  function()
    return char(0xf74a)
  end,
  color = { fg = colors.blue },
  padding = { left = 2, right = 1 },
  on_click = function()
    vim.cmd("Neotree toggle float")
  end,
})

-- current working directory
ins_left({
  function()
    return vim.fn.fnamemodify(vim.loop.cwd(), ":t")
  end,
  on_click = function()
    vim.cmd("Neotree toggle float")
  end,
})

-- git branch icon
ins_left({
  function()
    return char(0xfb2b)
  end,
  color = { fg = colors.orange },
  cond = conditions.check_git_workspace,
  padding = { left = 1, right = 0 },
  on_click = function()
    require("telescope.builtin").git_branches()
  end,
})

-- git branch
ins_left({
  "branch",
  icon = "",
  padding = { left = 0, right = 1 },
  on_click = function()
    require("telescope.builtin").git_branches()
  end,
})

-- diff
ins_left({
  "diff",
  symbols = {
    added = char(0xf457) .. " ",
    modified = char(0xf459) .. " ",
    removed = char(0xf458) .. " ",
  },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
  on_click = function()
    require("neogit").open()
  end,
})

local format_on_save_enabled = true

-- toggle format on save using lsp-format.nvim
ins_right({
  function()
    return " " .. char(0xfac7) .. " "
  end,
  color = function()
    local color = refreshable_color()()

    if format_on_save_enabled then
      color.fg = "bg"
      color.bg = colors.green
    end

    return color
  end,
  on_click = function()
    require("lsp-format").toggle({ args = "" })

    format_on_save_enabled = not format_on_save_enabled

    vim.notify(
      (format_on_save_enabled and "Enabled " or "Disabled ") .. "formatting on save",
      "info",
      { title = "Formatter" }
    )
  end,
})

-- spacer
ins_right({
  function()
    return "   "
  end,
})

-- lsp diagnostics
ins_right({
  "diagnostics",
  sources = {
    "nvim_diagnostic",
  },
  symbols = {
    error = char(0xf659) .. " ",
    warn = char(0xf529) .. " ",
    info = char(0xf7fc) .. " ",
  },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.blue },
  },
  on_click = function()
    require("telescope.builtin").diagnostics()
  end,
})

-- lsp no any diagnostics
ins_right({
  function()
    if #vim.opt_local.buftype:get() ~= 0 then
      return ""
    end

    return char(0xf633)
  end,
  cond = function()
    return vim.tbl_isempty(vim.diagnostic.get(0))
  end,
  color = { fg = colors.green },
})

-- lsp servers
ins_right({
  function()
    if #vim.opt_local.buftype:get() ~= 0 then
      return ""
    end

    local clients = {}

    for _, client in ipairs(vim.lsp.buf_get_clients()) do
      if client.name == "pyright" then
        if client.config.settings.python["pythonPath"] ~= nil then
          local venv_name = client.config.settings.python.venv_name or "venv"

          clients[#clients + 1] = client.name .. "(" .. venv_name .. ")"
        else
          clients[#clients + 1] = client.name
        end
      elseif client.name == "null-ls" then
        clients[#clients + 1] = "nls"
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
  color = { fg = colors.blue },
  on_click = function()
    vim.cmd("LspInfo")
  end,
})

-- line column icon
ins_right({
  function()
    return " "
  end,
  color = { fg = colors.green },
})

-- line column
ins_right({
  "location",
  padding = { right = 1 },
})

-- indent size
ins_right({
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
  end,
})

require("lualine").setup(config)
