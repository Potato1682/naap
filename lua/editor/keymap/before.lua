-- Non-plugin-related keymaps

local set = vim.keymap.set
local constants = require("core.constants")

if O.keymap.leader == " " then
  set("n", "<Space>", "")
end

vim.g.mapleader = O.keymap.leader
vim.g.maplocalleader = O.keymap.local_leader

local bufnr_keymap = function(bufnr)
  set("n", "<leader>" .. bufnr, function()
    local ok, bufferline = pcall(require, "bufferline")

    if not ok then
      vim.cmd("b " .. bufnr)

      return
    end

    bufferline.go_to_buffer(bufnr)
  end, {
    desc = "Buffer #" .. bufnr
  })
end

for i = 1, 9 do
  bufnr_keymap(i)
end

-- buffer movement, will be overidden by bufferline.nvim
set("n", "<Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if vim.tbl_contains(require("core.constants").window.ignore_buf_change_filetypes, filetype) then
    return
  end

  vim.cmd("bnext")
end, {
  desc = "Next Buffer"
})

set("n", "<S-Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if vim.tbl_contains(require("core.constants").window.ignore_buf_change_filetypes, filetype) then
    return
  end

  vim.cmd("bprev")
end, {
  desc = "Previous Buffer"
})

-- nohlsearch
set("n", "<Leader>h", function()
  vim.cmd("let @/=''")
end, {
  desc = "nohlsearch"
})

-- split
set("n", "s", "")
set("n", "ss", function()
  vim.cmd("split")
end, {
  desc = "Horizontal Split"
})

set("n", "sv", function()
  vim.cmd("vsplit")
end, {
  desc = "Vertical Split"
})

-- window movement
set("n", "<C-h>", "<C-w>h", {
  desc = "Left Window"
})

set("n", "<C-j>", "<C-w>j", {
  desc = "Down Window"
})

set("n", "<C-k>", "<C-w>k", {
  desc = "Up Window"
})

set("n", "<C-l>", "<C-w>l", {
  desc = "Right Window"
})
set("t", "<C-h>", [[<C-\><C-n><C-w>h]], {
  desc = "Left Window (in Terminal)"
})
set("t", "<C-j>", [[<C-\><C-n><C-w>j]], {
  desc = "Down Window (in Terminal)"
})
set("t", "<C-k>", [[<C-\><C-n><C-w>k]], {
  desc = "Up Window (in Terminal)"
})
set("t", "<C-l>", [[<C-\><C-n><C-w>l]], {
  desc = "Right Window (in Terminal)"
})

set("n", "Y", "yg$", {
  desc = "Yank after cursor"
})

-- join lines without moving cursor
set("n", "J", "mzJ`z", {
  desc = "Join lines"
})

-- beter indenting
set("v", "<", "<gv", {
  desc = "Indent Left"
})
set("v", ">", ">gv", {
  desc = "Indent Right"
})

-- better terminal esc
set("t", "<Esc>", [[<C-\><C-n>]], {
  desc = "Escape from Terminal"
})

for _, filetype in ipairs(constants.window.quit_with_q.filetypes) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      set("n", "q", function()
        vim.cmd("q")
      end, {
        buffer = true,
        desc = "Quit"
      })
    end
  })
end

for _, buftype in ipairs(constants.window.quit_with_q.buftypes) do
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
      if vim.opt_local.buftype:get() == buftype then
        set("n", "q", function()
          vim.cmd("q")
        end, {
          buffer = true,
          desc = "Quit"
        })
      end
    end
  })
end
