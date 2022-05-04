local M = {}

function M.gitsigns()
  require("gitsigns").setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr

        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true })

      -- Actions
      map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<cr>")
      map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<cr>")
      map("n", "<leader>gS", gs.stage_buffer)
      map("n", "<leader>gu", gs.undo_stage_hunk)
      map("n", "<leader>gR", gs.reset_buffer)
      map("n", "<leader>gp", gs.preview_hunk)
      map("n", "<leader>gb", function() gs.blame_line { full = true } end)
      map("n", "<leader>gb", gs.toggle_current_line_blame)
      map("n", "<leader>gd", gs.diffthis)
      map("n", "<leader>gD", function() gs.diffthis("~") end)
      map("n", "<leader>gtd", gs.toggle_deleted)

      -- Text object
      map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<cr>")
    end,
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    diff_opts = {
      algorithm = "histogram",
      internal = true
    },
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      delay = 400
    },
    preview_config = {
      border = "rounded",
      relative = "cursor",
      row = 0,
      col = 1
    }
  }

  vim.defer_fn(function()
    if O.editor.cursor_highlight.line then
      vim.cmd("hi link GitSignsCurrentLineBlame CursorLine")
    else
      vim.cmd("hi link GitSignsCurrentLineBlame Comment")
    end
  end, 200)
end

return M
