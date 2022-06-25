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
  vim.api.nvim_set_hl(0, "NavicArray",         { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicBoolean",       { link = "Boolean" })
  vim.api.nvim_set_hl(0, "NavicClass",         { link = "CmpItemKindClass" })
  vim.api.nvim_set_hl(0, "NavicConstant",      { link = "CmpItemKindConstant" })
  vim.api.nvim_set_hl(0, "NavicConstructor",   { link = "CmpItemKindConstructor" })
  vim.api.nvim_set_hl(0, "NavicEnum",          { link = "CmpItemKindEnum" })
  vim.api.nvim_set_hl(0, "NavicEnumMember",    { link = "CmpItemKindEnumMember" })
  vim.api.nvim_set_hl(0, "NavicEvent",         { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicField",         { link = "CmpItemKindField" })
  vim.api.nvim_set_hl(0, "NavicFile",          { link = "CmpItemKindFile" })
  vim.api.nvim_set_hl(0, "NavicFunction",      { link = "CmpItemKindFunction" })
  vim.api.nvim_set_hl(0, "NavicInterface",     { link = "CmpItemKindInterface" })
  vim.api.nvim_set_hl(0, "NavicKey",           { link = "Tag" })
  vim.api.nvim_set_hl(0, "NavicMethod",        { link = "CmpItemKindMethod" })
  vim.api.nvim_set_hl(0, "NavicModule",        { link = "CmpItemKindModule" })
  vim.api.nvim_set_hl(0, "NavicNamespace",     { link = "TSNamespace" })
  vim.api.nvim_set_hl(0, "NavicNull",          { link = "TSConstBuiltin" })
  vim.api.nvim_set_hl(0, "NavicNumber",        { link = "Number" })
  vim.api.nvim_set_hl(0, "NavicObject",        { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicOperator",      { link = "Operator" })
  vim.api.nvim_set_hl(0, "NavicPackage",       { link = "Special" })
  vim.api.nvim_set_hl(0, "NavicProperty",      { link = "CmpItemKindProperty" })
  vim.api.nvim_set_hl(0, "NavicSeparator",     { link = "LineNr" })
  vim.api.nvim_set_hl(0, "NavicString",        { link = "CmpItemKindKeyword" })
  vim.api.nvim_set_hl(0, "NavicStruct",        { link = "CmpItemKindStruct" })
  vim.api.nvim_set_hl(0, "NavicText",          { link = "Normal" })
  vim.api.nvim_set_hl(0, "NavicTypeParameter", { link = "Type" })
  vim.api.nvim_set_hl(0, "NavicVariable",      { link = "TSVariable" })

  vim.opt.winbar = [[ %{%v:lua.require("nvim-navic").get_location()%}]]
end

return M
