local constants = require("core.constants")

local data_dir = constants.data_dir

vim.opt.mouse = "a"
vim.opt.clipboard = {
  "unnamedplus"
}

vim.opt.shada = {
  "!",
  "'300",
  "<50",
  "@100",
  "s10",
  "h"
}

vim.opt.updatetime = 100
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = O.behavior.timeoutlen
vim.opt.ttimeoutlen = 10

vim.opt.showmode = false
vim.opt.cmdheight = 1
vim.opt.history = 10000

vim.opt.title = true
vim.opt.titlestring = "%<%F%=%l/%L - nvim"

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"

-- screen flicker workaround
vim.opt.winbar = " "

vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

vim.opt.inccommand = ""

vim.opt.textwidth = O.editor.textwidth
vim.opt.colorcolumn = "+1"

if O.editor.wrap then
  vim.opt.wrap = true
  vim.opt.breakat = vim.opt.breakat + [[、。・\ ]]
  vim.opt.breakindent = true

  vim.opt.breakindentopt = {
    shift = 2,
    min = 20,
  }

  vim.opt.showbreak = "⌐"
  vim.opt.cpoptions = vim.opt.cpoptions + "n"
else
  vim.opt.wrap = false
end

vim.opt.whichwrap = {
  b = true,
  s = true,
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
  h = true,
  l = true
}

vim.opt.fileencoding = "UTF-8"
vim.opt.fileformats = { "unix", "mac", "dos" }

vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = "useopen"

vim.opt.ruler = false

vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1

vim.opt.shortmess = {
  F = true,
  O = true,
  T = true,
  W = true,
  c = true,
  f = true,
  i = true,
  l = true,
  m = true,
  n = true,
  o = true,
  s = true,
  t = true,
  x = true
}

vim.opt.pumheight = 10
vim.opt.winblend = 17
vim.opt.winfixheight = true
vim.opt.winfixwidth = true
vim.opt.winaltkeys = "no"

vim.opt.scrolloff = O.editor.scrolling.scrolloff
vim.opt.sidescrolloff = O.editor.scrolling.sidescrolloff
vim.opt.sidescroll = 1

vim.opt.showtabline = 2

vim.opt.number = O.editor.number
vim.opt.relativenumber = O.editor.relative_number
vim.opt.cursorline = O.editor.cursor_highlight.line
vim.opt.cursorcolumn = O.editor.cursor_highlight.column
vim.opt.concealcursor = "nc"
vim.opt.signcolumn = "auto:3-4"
vim.opt.virtualedit = "onemore"
vim.opt.formatoptions = {
  ["1"] = true,
  M = true,
  c = false,
  j = true,
  l = true,
  m = true,
  n = true,
  o = false,
  q = true,
  r = false
}

vim.opt.matchpairs = {
  "(:)", "{:}",
  "[:]", "「:」",
  "（:）", "【:】",
  "『:』", "［:］",
  "｛:｝", "《:》",
  "〈:〉", "‘:’",
  "“:”"
}

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 9999

vim.opt.jumpoptions = "stack"

vim.opt.fillchars = {
  eob = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = ""
}

vim.opt.list = O.editor.listchars
vim.opt.listchars = {
  eol = "¬",
  precedes = "<",
  extends = ">",
  nbsp = "•"
}

vim.opt.viewoptions = {
  "cursor",
  "folds",
  "curdir",
  "slash",
  "unix"
}

vim.opt.synmaxcol = 2500

-- backup is executed by other plugin
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

vim.opt.autowrite = true
vim.opt.writeany = true

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "winsize",
  "winpos",
  "terminal"
}

vim.opt.sh = O.terminal.shell

vim.opt.errorbells = false

vim.opt.exrc = true
vim.opt.secure = true

vim.opt.undodir = join_paths(data_dir, "undos")
vim.opt.undofile = true

vim.opt.spell = O.editor.spell_check

vim.opt.guifont = string.format("%s %d", O.editor.gui.font_family, O.editor.gui.font_size)
