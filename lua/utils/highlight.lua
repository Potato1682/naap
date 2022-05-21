local M = {}

function M.get_color_code_from_hl_name(name, ns)
  local hl = vim.api.nvim_get_hl_by_name(name, ns)
  local code

  if ns == "guifg" then
    code = hl.foreground
  elseif ns == "guibg" then
    code = hl.background
  elseif ns == "guisp" then
    code = hl.special
  end

  if not code then
    error("No color code found for " .. name)
  end

  return string.format("%x", code)
end

return M
