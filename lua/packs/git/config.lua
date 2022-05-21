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
    word_diff = O.git.word_diff,
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
      end, {
        expr = true,
        desc = "Next Hunk"
      })

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, {
        expr = true,
        desc = "Previous Hunk"
      })

      -- Actions
      map({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", {
        silent = true,
        desc = "Stage Hunk"
      })
      map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {
        silent = true,
        desc = "Unstage Hunk"
      })
      map("n", "<leader>gS", gs.stage_buffer, {
        desc = "Stage Buffer"
      })
      map("n", "<leader>gu", gs.undo_stage_hunk, {
        desc = "Undo Stage Hunk"
      })
      map("n", "<leader>gR", gs.reset_buffer, {
        desc = "Reset Buffer"
      })
      map("n", "<leader>gp", gs.preview_hunk, {
        desc = "Preview Hunk"
      })
      map("n", "<leader>gB", function()
        gs.blame_line { full = true }
      end, {
        desc = "Blame Line"
      })
      map("n", "<leader>gT", gs.toggle_current_line_blame, {
        desc = "Toggle Current-line Blame"
      })
      map("n", "<leader>gd", gs.diffthis, {
        desc = "Diff This"
      })
      map("n", "<leader>gD", function() gs.diffthis("~") end, {
        desc = "Diff Current Buffer"
      })
      map("n", "<leader>gt", gs.toggle_deleted, {
        desc = "Toggle Deleted"
      })

      -- Text object
      map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>", {
        silent = true,
        desc = "Select Hunk"
      })
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
    current_line_blame = O.git.current_line_blame,
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

function M.diffview()
  require("diffview").setup {
    enhanced_diff_hl = true
  }
end

function M.neogit_setup()
  vim.keymap.set("n", "<leader>gg", function()
    require("neogit").open()
  end, {
    desc = "Open Neogit"
  })
end

function M.neogit()
  require("neogit").setup {
    use_magit_keybindings = O.git.magit_keybindings,
    integrations = {
      diffview = true
    }
  }
end

function M.conflict_setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
      vim.defer_fn(function()
        vim.notify("Conflict detected, need to resolve conflicts.", vim.log.levels.WARN, { title = "Git" })
      end, 50)

      local set = function(lhs, rhs, opts)
        vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { buffer = true }))
      end

      set("<leader>gco", "<Plug>(git-conflict-ours)", { desc = "Choose Ours" })
      set("<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Choose Both" })
      set("<leader>gc0", "<Plug>(git-conflict-none)", { desc = "Choose None" })
      set("<leader>gct", "<Plug>(git-conflict-theirs)", { desc = "Choose Theirs" })
      set("<leader>[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next Git Conflict" })
      set("<leader>]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous Git Conflict" })
    end
  })
end

function M.conflict()
  require("git-conflict").setup {
    default_mappings = false,
    highlights = {
      incoming = "Visual",
      current = "DiffAdd"
    }
  }
end

return M
