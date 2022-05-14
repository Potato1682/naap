local loader = require("packer").loader

_G.PLoader = loader

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*",
  callback = function()
    local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))

    if fsize == nil or fsize < 0 then
      fsize = 1
    end

    local load_treesitter = true
    local load_lsp = true

    if fsize > 1024 * 1024 then
      load_treesitter = false
      load_lsp = false
    end

    if fsize > 6 * 1024 * 1024 then
      vim.notify(
        "Filesize is too large, disabling syntax highlighting",
        vim.log.levels.WARN, {
        title = "Lazy (core)"
      }
      )

      vim.cmd("syntax off")
    end

    if require("core.git").check_git_workspace() then
      loader("gitsigns.nvim")
    end

    if load_lsp then
      loader("nvim-lspconfig")
      loader("nvim-lsp-installer")

      require("configs.lsp")
    end

    if load_treesitter then
      loader("nvim-treesitter")
    end
  end
})

local lazy_load = function()
  local disable_filetypes = {
    "packer",
    "TelescopePrompt",
    "csv",
    "txt"
  }

  local syntax_on = not vim.tbl_contains(disable_filetypes, vim.opt_local.filetype:get())

  if not syntax_on then
    vim.cmd("syntax manual")
  end
end

vim.defer_fn(function()
  vim.cmd("doautocmd User LoadLazyPlugin")
end, 30)

vim.api.nvim_create_autocmd("User LoadLazyPlugin", {
  callback = function()
    lazy_load()
  end
})

-- nvim-cmp
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  once = true,
  callback = function()
    loader("nvim-cmp")

    require("packs.completion.config").cmp()
  end
})
