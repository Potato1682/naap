return {
  appearance = {
    colorscheme = "tokyonight"
  },
  behavior = {
    timeoutlen = 350
  },
  editor = {
    cursor_highlight = {
      line = true,
      column = false
    },
    folding = {
      starting_level = 4
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
  terminal = {
    shell = vim.env.SHELL
  }
}

