local M = {}

function M.neodev()
  require("neodev").setup({
    lspconfig = false,
  })
end

function M.autolist()
  local autolist = require("autolist")

  autolist.setup()

  local augroup = vim.api.nvim_create_augroup("autolist-keymap", {})

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "markdown",
    callback = function()
      local function keymap(mode, mapping, hook, alias)
        vim.keymap.set(mode, mapping, function(motion)
          local keys = hook(motion, alias or mapping)
          if not keys then
            keys = ""
          end
          return keys
        end, { expr = true, buffer = true })
      end

      keymap("n", "dd", autolist.force_recalculate)
      keymap("n", "o", autolist.new)
      keymap("n", "O", autolist.new_before)
      keymap("n", ">>", autolist.indent)
      keymap("n", "<<", autolist.indent)
      keymap("n", "<C-r>", autolist.force_recalculate)
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    callback = function()
      if vim.opt_local.filetype ~= "markdown" then
        return
      end

      local function keymap_with_fallback(mode, mapping, hook, alias)
        -- if the requested mapping is occupied, add current function to it

        local additional_map = nil
        local maps = vim.api.nvim_get_keymap(mode)

        for _, map in ipairs(maps) do
          if map.lhs == mapping then
            if map.rhs then
              additional_map = map.rhs:gsub("^v:lua%.", "", 1)
            else
              additional_map = map.callback
            end

            pcall(vim.keymap.del, mode, mapping)
          end
        end

        vim.keymap.set(mode, mapping, function(motion)
          if additional_map then
            if type(additional_map) == "string" then
              local ok, result = pcall(load, "return " .. additional_map)

              if ok then
                vim.fn.feedkeys(result, "nt")
              end
            else
              vim.fn.feedkeys(additional_map(), "nt")
            end
          end

          return hook(motion, alias or mapping) or ""
        end, { expr = true, remap = true })
      end

      keymap_with_fallback("i", "<cr>", autolist.new)
      keymap_with_fallback("i", "<Tab>", autolist.indent)
      keymap_with_fallback("i", "<S-Tab>", autolist.indent, "<C-d>")
    end,
  })
end

return M
