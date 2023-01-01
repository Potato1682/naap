return {
  appearance = {
    transparency = false
  },
  behavior = {
    timeoutlen = 350
  },
  editor = {
    abbreviations = {},
    cursor_highlight = {
      line = true,
      column = false
    },
    gui = {
      font_family = "Monospace",
      font_size = 13
    },
    listchars = false,
    number = true,
    relative_number = true,
    scrolling = {
      scrolloff = 4,
      sidescrolloff = 16
    },
    spell_check = true,
    textwidth = 120,
    wrap = true,
  },
  database = {
    servers = {}
  },
  debug = {
    virtual_text = {
      commented = false
    }
  },
  git = {
    current_line_blame = true,
    magit_keybindings = false,
    github_hostname = "",
    word_diff = false
  },
  extras = {
    toggle = {
      toggle_chars = {}
    }
  },
  lang = {
    insert_comma_after_final_obj = false,
    json = {
      -- SchemaStore.nvim custom schemas
      custom_schemas = {}
    }
  },
  keymap = {
    leader = " ",
    local_leader = ","
  },
  sessions = {
    autosave = true,
    autoload = false,
    allowed_dirs = {},
    ignored_dirs = {}
  },
  terminal = {
    shell = vim.env.SHELL
  }
}
