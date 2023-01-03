local uv = vim.loop

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*",
  callback = function()
    local max_buf_size = 6 * 1024 * 1024 -- 6MiB
    local ok, stat = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(0))

    if not ok then
      return
    end

    if not stat then
      return
    end

    local buf_size = stat.size

    if buf_size <= max_buf_size then
      return
    end

    vim.notify("File size is too large, disabling syntax highlighting", "warning", { title = "Core" })

    vim.cmd.syntax("off")
  end,
})
