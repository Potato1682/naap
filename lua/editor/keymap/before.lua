-- Non-plugin-related keymaps

local keymap = require("utils.keymap").keymap
local constants = require("core.constants")

if O.keymap.leader == " " then
  keymap("n", "<Space>", "")
end

vim.g.mapleader = O.keymap.leader
vim.g.maplocalleader = O.keymap.local_leader

local bufnr_keymap = function(bufnr)
  keymap("n", "<leader>" .. bufnr, function()
    local ok, bufferline = pcall(require, "bufferline")

    if not ok then
      vim.cmd("b " .. bufnr)

      return
    end

    bufferline.go_to_buffer(bufnr)
  end, "Buffer #" .. bufnr)
end

for i = 1, 9 do
  bufnr_keymap(i)
end

-- buffer movement, will be overidden by cybu.nvim
keymap("n", "<Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if vim.tbl_contains(require("core.constants").window.ignore_buf_change_filetypes, filetype) then
    return
  end

  vim.cmd("bnext")
end, "Next Buffer")

keymap("n", "<S-Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if vim.tbl_contains(require("core.constants").window.ignore_buf_change_filetypes, filetype) then
    return
  end

  vim.cmd("bprev")
end, "Previous Buffer")

-- nohlsearch
keymap("n", "<Leader>h", function()
  vim.cmd("let @/=''")
end, "nohlsearch")

-- split
keymap("n", "s", "")
keymap("n", "ss", function()
  vim.cmd("split")
end, "Horizontal Split")

keymap("n", "sv", function()
  vim.cmd("vsplit")
end, "Vertical Split")

-- window movement
keymap("n", "<C-h>", "<C-w>h", "Left Window")
keymap("n", "<C-j>", "<C-w>j", "Down Window")
keymap("n", "<C-k>", "<C-w>k", "Up Window")
keymap("n", "<C-l>", "<C-w>l", "Right Window")
keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Left Window (in Terminal)")
keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], "Down Window (in Terminal)")
keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Up Window (in Terminal)")
keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], "Right Window (in Terminal)")

keymap("n", "Y", "yg$", "Yank after cursor")

-- join lines without moving cursor
keymap("n", "J", "mzJ`z", "Join lines")

-- beter indenting
keymap("v", "<", "<gv", "Indent Left")
keymap("v", ">", ">gv", "Indent Right")

-- better terminal esc
keymap("t", "<Esc>", [[<C-\><C-n>]], "Escape from Terminal")

for _, filetype in ipairs(constants.window.quit_with_q.filetypes) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      keymap("n", "q", function()
        vim.cmd("q")
      end, "Quit", {
        buffer = true
      })
    end
  })
end

for _, buftype in ipairs(constants.window.quit_with_q.buftypes) do
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
      if vim.opt_local.buftype:get() == buftype then
        keymap("n", "q", function()
          vim.cmd("q")
        end, "Quit", {
          buffer = true
        })
      end
    end
  })
end
