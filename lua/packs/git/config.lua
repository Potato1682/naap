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
      local presets = require("utils.keymap.presets")

      local leader_visual_keymap = presets.leader({ "n", "v" }, "g", {
        buffer = bufnr,
        silent = true
      })

      local leader_keymap = presets.leader("n", "g", { buffer = bufnr })
      local keymap = presets.mode_only("n", { buffer = bufnr, expr = true })

      -- Navigation
      keymap("]c", function()
        if vim.wo.diff then
          return "]c"
        end

        vim.schedule(function()
          gs.next_hunk()
        end)

        return "<Ignore>"
      end, "Next Hunk")

      keymap("[c", function()
        if vim.wo.diff then
          return "[c"
        end

        vim.schedule(function()
          gs.prev_hunk()
        end)

        return "<Ignore>"
      end, "Previous Hunk")

      -- Actions
      leader_visual_keymap("s", function()
        vim.cmd("Gitsigns stage_hunk")
      end, "Stage Hunk")
      leader_visual_keymap("r", function()
        vim.cmd("Gitsigns reset_hunk")
      end, "Unstage Hunk")

      leader_keymap("S", gs.stage_buffer, "Stage Buffer")
      leader_keymap("u", gs.undo_stage_hunk, "Undo Stage Hunk")
      leader_keymap("R", gs.reset_buffer, "Unstage Buffer")
      leader_keymap("p", gs.preview_hunk, "Preview Hunk")
      leader_keymap("B", function()
        gs.blame_line {
          full = true
        }
      end, "Blame Line")
      leader_keymap("T", gs.toggle_current_line_blame, "Toggle Current Line Blame")
      leader_keymap("d", gs.diffthis, "Diff This")
      leader_keymap("D", function()
        gs.diffthis("~")
      end, "Diff Current Buffer")
      leader_keymap("t", gs.toggle_deleted, "Toggle Deleted")

      -- Text object
      require("utils.keymap").keymap({ "o", "x" }, "ih", function()
        vim.cmd("Gitsigns select_hunk")
      end, "Select Hunk", {
        silent = true
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
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
        link = "CursorLine"
      })
    else
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
        link = "Comment"
      })
    end
  end, 200)
end

function M.diffview()
  require("diffview").setup {
    enhanced_diff_hl = true
  }
end

function M.neogit_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>gg", function()
    require("neogit").open()
  end, "Open Neogit")
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

      local leader_keymap = require("utils.keymap.presets").leader("n", "gc", { buffer = true })
      local keymap = require("utils.keymap.presets").mode_only("n", { buffer = true })

      leader_keymap("o", "<Plug>(git-conflict-ours)", "Choose Ours")
      leader_keymap("b", "<Plug>(git-conflict-both)", "Choose Both")
      leader_keymap("0", "<Plug>(git-conflict-none)", "Choose None")
      leader_keymap("t", "<Plug>(git-conflict-theirs)", "Choose Theirs")

      keymap("[x", "<Plug>(git-conflict-next-conflict)", "Next Git Conflict")
      keymap("]x", "<Plug>(git-conflict-prev-conflict)", "Previous Git Conflict")
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
