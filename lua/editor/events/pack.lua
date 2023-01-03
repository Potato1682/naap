local M = {}

local api = vim.api

function M.setup()
  local compile_group = api.nvim_create_augroup("compile", {})

  api.nvim_create_autocmd("User", {
    group = compile_group,
    pattern = "PackerCompileDone",
    callback = function()
      vim.notify("compile: done", vim.log.levels.INFO, { title = "Pack" })
    end,
    desc = "Send notification when packer compilations are done",
  })
end

return M
