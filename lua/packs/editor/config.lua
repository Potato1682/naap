local M = {}

function M.smartpairs()
  require("pairs"):setup {
    enter = {
      enable_mapping = false
    },
    autojump_strategy = {
      unbalanced = "all"
    },
    enable_smart_space = true
  }
end

function M.hlslens_setup()
  local map = function(lhs, rhs, options)
    vim.keymap.set("n", lhs, rhs, options or {})
  end

  map("n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", {
    silent = true,
    desc = "Next search hit"
  })
  map("N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", {
    silent = true,
    desc = "Previous search hit"
  })

  map("*", function()
    require("hlslens").start()
  end, {
    desc = "Search"
  })
  map("#", function()
    require("hlslens").start()
  end, {
    desc = "Search"
  })
  map("g*", function()
    require("hlslens").start()
  end, {
    desc = "Search"
  })
  map("g#", function()
    require("hlslens").start()
  end, {
    desc = "Search"
  })
end

function M.accelerated_jk()
  vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", {
    desc = "Down"
  })
  vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", {
    desc = "Up"
  })
end

function M.cinnamon()
  require("cinnamon").setup {
    extra_keymaps = true,
    scroll_limit = 100
  }
end

function M.houdini()
  require("houdini").setup {
    mappings = {
      "jk",
      "AA",
      "II"
    },
    escape_sequences = {
      i = function(first, second)
        local seq = first .. second


        if seq == "AA" then
          return "<BS><BS><End>"
        end

        if seq == "II" then
          return "<BS><BS><Home>"
        end

        return "<BS><BS><ESC>"
      end
    }
  }
end

function M.fF_highlight()
  require("fFHighlight").setup()
end

function M.marks()
  require("marks").setup {
    force_write_shada = true
  }
end

function M.comment()
  require("Comment").setup {
    pre_hook = function(context)
      local utils = require("Comment.utils")

      local type = context.ctype == utils.ctype.line and "__default" or "__multiline"

      local location = nil

      if context.ctype == utils.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif context.cmotion == utils.cmotion.v or context.cmotion == utils.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
        key = type,
        location = location
      }
    end
  }
end

function M.abbreinder()
  require("abbreinder").setup()
end

function M.hclipboard()
  require("hclipboard").start()
end

function M.trouble()
  require("trouble").setup {
    auto_close = true
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "Trouble",
    callback = function()
      vim.opt_local.colorcolumn = ""
    end
  })
end

return M
