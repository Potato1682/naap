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
  local keymap = require("utils.keymap.presets").mode_only("n", { silent = true })

  keymap(
    "n",
    function()
      require("cinnamon.scroll").scroll(vim.v.count1 .. "n", 1, 0, 3)
      vim.api.nvim_feedkeys("zzzv", "n", true)

      require("hlslens").start()
    end,
    "Next search hit"
  )
  keymap(
    "N",
    function()
      require("cinnamon.scroll").scroll(vim.v.count1 .. "N", 1, 0, 3)
      vim.api.nvim_feedkeys("zzzv", "n", true)

      require("hlslens").start()
    end,
    "Previous search hit"
  )

  keymap("*", function()
    require("hlslens").start()
  end, "Search")
  keymap("#", function()
    require("hlslens").start()
  end, "Search")
  keymap("g*", function()
    require("hlslens").start()
  end, "Search")
  keymap("g#", function()
    require("hlslens").start()
  end, "Search")
end

function M.accelerated_jk()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("j", "<Plug>(accelerated_jk_gj)", "Down")
  keymap("k", "<Plug>(accelerated_jk_gk)", "Up")
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

function M.colorizer()
  require("colorizer").setup()
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

function M.todo_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>t", function()
    vim.cmd("TodoTelescope")
  end, "Todos")
end

function M.todo()
  require("todo-comments").setup()

  require("utils.telescope").register_extension("todo-comments")
end

function M.pqf()
  local char = require("utf8").char

  require("pqf").setup {
    signs = {
      error = char(0xf659),
      warn = char(0xf529),
      info = char(0xf7fc),
      hint = char(0xf835)
    }
  }
end

return M
