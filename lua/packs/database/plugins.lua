local database = {}

database["tpope/vim-dadbod"] = {
  cmd = "DB",
}

database["kristijanhusak/vim-dadbod-ui"] = {
  cmd = "DBUI",

  setup = function()
    require("packs.database.config").dbui_setup()
  end,

  config = function()
    vim.cmd("packadd vim-dadbod")
  end,
}

return database
