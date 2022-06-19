local M = {}
local ns = vim.api.nvim_create_namespace("naap_signs")

function M.add_margin()
  for lnum = 1, vim.api.nvim_buf_line_count(0) do
    vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, -1, {
      id = lnum,
      sign_text = " ",
      priority = 1,
      sign_hl_group = "Normal",
      number_hl_group = nil,
      line_hl_group = nil
    })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufWritePost", "TextChanged", "TextChangedI" }, {
    pattern = "*",
    callback = function()
      M.add_margin()
    end
  })
end

return M
