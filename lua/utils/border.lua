local M = {}

local border_double = {
  { "╔", "FloatBorder" },
  { "═", "FloatBorder" },
  { "╗", "FloatBorder" },
  { "║", "FloatBorder" },
  { "╝", "FloatBorder" },
  { "═", "FloatBorder" },
  { "╚", "FloatBorder" },
  { "║", "FloatBorder" },
}

local border_rounded = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

function M.get_border_char_and_hl(name)
  local border = border_rounded

  if name == "double" then
    border = border_double
  end

  -- fallbcak
  return border
end

function M.get_border_chars(name)
  local border = border_rounded

  if name == "double" then
    border = border_double
  end

  local result = {}

  for _, v in ipairs(border) do
    table.insert(result, v[1])
  end

  return result
end

return M
