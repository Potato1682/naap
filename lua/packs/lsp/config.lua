local M = {}

-- minimal configurations, big configurations should be in lua/configs/lsp.lua

function M.lightbulb_setup()
  local augroup = vim.api.nvim_create_augroup("lightbulb", {})

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = augroup,
    callback = function()
      require("nvim-lightbulb").update_lightbulb {
        ignore = {
          "null-ls"
        }
      }
    end
  })
end

function M.lightbulb()
  require("nvim-lightbulb").setup {
    ignore = {
      "null-ls"
    },
    sign = {
      enabled = false
    },
    float = {
      enabled = true,
    }
  }
end

function M.goto_preview_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "gP", function()
    require("goto-preview").close_all_win()
  end, "Close All Preview Windows")
end

function M.goto_preview()
  local keymap = require("utils.keymap").keymap

  require("goto-preview").setup {
    post_open_hook = function()
      keymap("n", "q", "<cmd>q!<cr>", {
        buffer = true
      })
    end
  }

  require("utils.telescope").register_extension("gotopreview")
end

function M.hover_setup()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("K", function()
    require("hover").hover()
  end, "hover.nvim")
  keymap("gK", function()
    require("hover").hover_select()
  end, "hover.nvim (select provider)")

  vim.api.nvim_create_user_command("Hover", function()
    require("hover").hover()
  end, {
    nargs = "*",
    desc = "hover.nvim"
  })
end

function M.hover()
  require("hover").setup {
    init = function()
      require("hover.providers.lsp")
      require("hover.providers.gh")
    end,
    preview_opts = {
      border = "rounded"
    },
    title = false
  }
end

function M.navic()
  require("nvim-navic").setup {
    icons = require("utils.lsp.kind"),
    highlight = true
  }

  -- enabled to suppress annoying errors
  vim.g.navic_silence = true

  -- define hl
  vim.api.nvim_set_hl(0, "NavicText",               { link = "Normal" })
  vim.api.nvim_set_hl(0, "NavicSeparator",          { link = "LineNr" })
  vim.api.nvim_set_hl(0, "NavicIconsArray",         { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicIconsBoolean",       { link = "Boolean" })
  vim.api.nvim_set_hl(0, "NavicIconsClass",         { link = "CmpItemKindClass" })
  vim.api.nvim_set_hl(0, "NavicIconsConstant",      { link = "CmpItemKindConstant" })
  vim.api.nvim_set_hl(0, "NavicIconsConstructor",   { link = "CmpItemKindConstructor" })
  vim.api.nvim_set_hl(0, "NavicIconsEnum",          { link = "CmpItemKindEnum" })
  vim.api.nvim_set_hl(0, "NavicIconsEnumMember",    { link = "CmpItemKindEnumMember" })
  vim.api.nvim_set_hl(0, "NavicIconsEvent",         { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicIconsField",         { link = "CmpItemKindField" })
  vim.api.nvim_set_hl(0, "NavicIconsFile",          { link = "CmpItemKindFile" })
  vim.api.nvim_set_hl(0, "NavicIconsFunction",      { link = "CmpItemKindFunction" })
  vim.api.nvim_set_hl(0, "NavicIconsInterface",     { link = "CmpItemKindInterface" })
  vim.api.nvim_set_hl(0, "NavicIconsKey",           { link = "Tag" })
  vim.api.nvim_set_hl(0, "NavicIconsMethod",        { link = "CmpItemKindMethod" })
  vim.api.nvim_set_hl(0, "NavicIconsModule",        { link = "CmpItemKindModule" })
  vim.api.nvim_set_hl(0, "NavicIconsNamespace",     { link = "TSNamespace" })
  vim.api.nvim_set_hl(0, "NavicIconsNull",          { link = "TSConstBuiltin" })
  vim.api.nvim_set_hl(0, "NavicIconsNumber",        { link = "Number" })
  vim.api.nvim_set_hl(0, "NavicIconsObject",        { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicIconsOperator",      { link = "Operator" })
  vim.api.nvim_set_hl(0, "NavicIconsPackage",       { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicIconsProperty",      { link = "CmpItemKindProperty" })
  vim.api.nvim_set_hl(0, "NavicIconsString",        { link = "CmpItemKindKeyword" })
  vim.api.nvim_set_hl(0, "NavicIconsStruct",        { link = "CmpItemKindStruct" })
  vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "Type" })
  vim.api.nvim_set_hl(0, "NavicIconsVariable",      { link = "TSVariable" })

  vim.opt.winbar = [[ %{%v:lua.require("nvim-navic").get_location()%}]]
end

return M
