local lang = {}

-- Json
lang["b0o/SchemaStore.nvim"] = {
  module = "schemastore",
}

-- Lua
lang["folke/neodev.nvim"] = {
  module = "neodev",

  config = function()
    require("packs.lang.config").neodev()
  end,
}

-- Python
lang["HallerPatrick/py_lsp.nvim"] = {
  module = "py_lsp",
}

-- Markdown
lang["gaoDean/autolist.nvim"] = {
  ft = "markdown",

  module = "autolist",

  config = function()
    require("packs.lang.config").autolist()
  end,
}

return lang
