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

function M.octo()
  require("octo").setup {
    github_hostname = O.git.github_hostname,
    mappings = {
      issue = {
        close_issue = "<localleader>ic", -- close issue
        reopen_issue = "<localleader>io", -- reopen issue
        list_issues = "<localleader>il", -- list open issues on same repo
        reload = "<C-r>", -- reload issue
        open_in_browser = "<C-b>", -- open issue in browser
        copy_url = "<C-y>", -- copy url to system clipboard
        add_assignee = "<localleader>aa", -- add assignee
        remove_assignee = "<localleader>ad", -- remove assignee
        create_label = "<localleader>lc", -- create label
        add_label = "<localleader>la", -- add label
        remove_label = "<localleader>ld", -- remove label
        goto_issue = "<localleader>gi", -- navigate to a local repo issue
        add_comment = "<localleader>ca", -- add comment
        delete_comment = "<localleader>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        react_hooray = "<localleader>rp", -- add/remove 🎉 reaction
        react_heart = "<localleader>rh", -- add/remove ❤️ reaction
        react_eyes = "<localleader>re", -- add/remove 👀 reaction
        react_thumbs_up = "<localleader>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<localleader>r-", -- add/remove 👎 reaction
        react_rocket = "<localleader>rr", -- add/remove 🚀 reaction
        react_laugh = "<localleader>rl", -- add/remove 😄 reaction
        react_confused = "<localleader>rc", -- add/remove 😕 reaction
      },
      pull_request = {
        checkout_pr = "<localleader>po", -- checkout PR
        merge_pr = "<localleader>pm", -- merge commit PR
        squash_and_merge_pr = "<localleader>psm", -- squash and merge PR
        list_commits = "<localleader>pc", -- list PR commits
        list_changed_files = "<localleader>pf", -- list PR changed files
        show_pr_diff = "<localleader>pd", -- show PR diff
        add_reviewer = "<localleader>va", -- add reviewer
        remove_reviewer = "<localleader>vd", -- remove reviewer request
        close_issue = "<localleader>ic", -- close PR
        reopen_issue = "<localleader>io", -- reopen PR
        list_issues = "<localleader>il", -- list open issues on same repo
        reload = "<C-r>", -- reload PR
        open_in_browser = "<C-b>", -- open PR in browser
        copy_url = "<C-y>", -- copy url to system clipboard
        add_assignee = "<localleader>aa", -- add assignee
        remove_assignee = "<localleader>ad", -- remove assignee
        create_label = "<localleader>lc", -- create label
        add_label = "<localleader>la", -- add label
        remove_label = "<localleader>ld", -- remove label
        goto_issue = "<localleader>gi", -- navigate to a local repo issue
        add_comment = "<localleader>ca", -- add comment
        delete_comment = "<localleader>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        react_hooray = "<localleader>rp", -- add/remove 🎉 reaction
        react_heart = "<localleader>rh", -- add/remove ❤️ reaction
        react_eyes = "<localleader>re", -- add/remove 👀 reaction
        react_thumbs_up = "<localleader>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<localleader>r-", -- add/remove 👎 reaction
        react_rocket = "<localleader>rr", -- add/remove 🚀 reaction
        react_laugh = "<localleader>rl", -- add/remove 😄 reaction
        react_confused = "<localleader>rc", -- add/remove 😕 reaction
      },
      review_thread = {
        goto_issue = "<localleader>gi", -- navigate to a local repo issue
        add_comment = "<localleader>ca", -- add comment
        add_suggestion = "<localleader>sa", -- add suggestion
        delete_comment = "<localleader>cd", -- delete comment
        next_comment = "]c", -- go to next comment
        prev_comment = "[c", -- go to previous comment
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        react_hooray = "<localleader>rp", -- add/remove 🎉 reaction
        react_heart = "<localleader>rh", -- add/remove ❤️ reaction
        react_eyes = "<localleader>re", -- add/remove 👀 reaction
        react_thumbs_up = "<localleader>r+", -- add/remove 👍 reaction
        react_thumbs_down = "<localleader>r-", -- add/remove 👎 reaction
        react_rocket = "<localleader>rr", -- add/remove 🚀 reaction
        react_laugh = "<localleader>rl", -- add/remove 😄 reaction
        react_confused = "<localleader>rc", -- add/remove 😕 reaction
      },
      submit_win = {
        approve_review = "<C-a>", -- approve review
        comment_review = "<C-m>", -- comment review
        request_changes = "<C-r>", -- request changes review
        close_review_tab = "<C-c>", -- close review tab
      },
      review_diff = {
        add_review_comment = "<localleader>ca", -- add a new review comment
        add_review_suggestion = "<localleader>sa", -- add a new review suggestion
        focus_files = "<leader>e", -- move focus to changed file panel
        toggle_files = "<leader>b", -- hide/show changed files panel
        next_thread = "]t", -- move to next thread
        prev_thread = "[t", -- move to previous thread
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        toggle_viewed = "<leader><space>", -- toggle viewer viewed state
      },
      file_panel = {
        next_entry = "j", -- move to next changed file
        prev_entry = "k", -- move to previous changed file
        select_entry = "<cr>", -- show selected changed file diffs
        refresh_files = "R", -- refresh changed files panel
        focus_files = "<leader>e", -- move focus to changed file panel
        toggle_files = "<leader>b", -- hide/show changed files panel
        select_next_entry = "]q", -- move to previous changed file
        select_prev_entry = "[q", -- move to next changed file
        close_review_tab = "<C-c>", -- close review tab
        toggle_viewed = "<leader><space>", -- toggle viewer viewed state
      }
    }
  }
end

return M
