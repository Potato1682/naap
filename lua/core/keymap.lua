-- Non-plugin-related keymaps

local set = vim.keymap.set

if O.keymap.leader == " " then
  set("n", "<Space>", "")
end

vim.g.mapleader = O.keymap.leader
vim.g.maplocalleader = O.keymap.local_leader

-- buffer movement, will be overidden by bufferline.nvim
set("n", "<Tab>", function()
  vim.cmd("bnext")
end)
set("n", "<S-Tab>", function()
  vim.cmd("bprev")
end)

-- nohlsearch
set("n", "<Leader>h", function()
  vim.cmd("let @/=''")
end)

-- split
set("n", "s", "")
set("n", "ss", function()
  vim.cmd("split")
end)
set("n", "sv", function()
  vim.cmd("vsplit")
end)

-- window movement
set("n", "<C-h>", "<C-w>h")
set("n", "<C-j>", "<C-w>j")
set("n", "<C-k>", "<C-w>k")
set("n", "<C-l>", "<C-w>l")

-- beter indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

