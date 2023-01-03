local database = {}

database["kristijanhusak/vim-dadbod-ui"] = {
  requires = {
    { "tpope/vim-dadbod", cmd = "DB" },
  },

  wants = {
    "vim-dadbod",
  },

  cmd = "DBUI",

  setup = function()
    require("packs.database.config").dbui_setup()
  end,
}

return database
