local M = {}

local char = require("utf8").char

local symbol_enabled = char(0xe34c)
local symbol_enabled_fg = "#eea825"
local symbol_disabled = char(0xfa93)
local symbol_disabled_fg = "#007bff"
local toggle_enabled = " "
local toggle_enabled_fg = "#007bff"
local toggle_disabled = " "
local toggle_disabled_fg = "#abb2bf"

local old_theme = nil

function M.toggle_enable()
  vim.g.toggle_icon = toggle_enabled
  vim.g.toggle_icon_fg = toggle_enabled_fg
  vim.g.symbol_icon = symbol_enabled
  vim.g.symbol_icon_fg = symbol_enabled_fg
end

function M.toggle_disable()
  vim.g.toggle_icon = toggle_disabled
  vim.g.toggle_icon_fg = toggle_disabled_fg
  vim.g.symbol_icon = symbol_disabled
  vim.g.symbol_icon_fg = symbol_disabled_fg
end

-- Some code from max397574/ignis-nvim
function M.toggle_light_dark()
  if vim.g.light_theme then
    if vim.g.colors_name ~= vim.g.light_theme then
      old_theme = vim.g.colors_name

      vim.cmd("colorscheme " .. vim.g.light_theme)

      M.toggle_enable()
    else
      vim.cmd("colorscheme " .. old_theme)

      M.toggle_disable()
    end

    return
  end

  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"

    M.toggle_enable()

    return
  end

  vim.opt.background = "dark"

  M.toggle_disable()
end

function M.setup()
  if vim.g.light_theme then
    if vim.g.colors_name ~= vim.g.light_theme then
      M.toggle_disable()

      return
    end

    M.toggle_enable()

    return
  end

  if vim.opt.background:get() == "dark" then
    M.toggle_disable()

    return
  end

  M.toggle_enable()
end

M.setup()

return M
