local M = {}

local uv = vim.loop

function M.treesitter()
  if _G.__nvim_treesitter_setup_done then
    return
  end

  local augroup = vim.api.nvim_create_augroup("treesitter-fold", {})

  vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
    group = augroup,
    callback = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  })

  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- We need this
      "lua",

      -- noice.nvim prerequisites (also lua is in them)
      "vim",
      "regex",
      "bash",
      "markdown",
      "markdown_inline",
    },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local max_buf_size = 100 * 1024
        local ok, stat = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))

        if not ok then
          return false
        end

        if not stat then
          return false
        end

        local buf_size = stat.size

        if buf_size > max_buf_size then
          vim.notify(
            "File size is bigger than 100KiB, disabling nvim-treesitter highlighting",
            "warning",
            { title = "nvim-treesitter" }
          )

          return true
        end

        return false
      end,
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 2000,
    },
    indent = { enable = false },
    yati = { enable = true },
    endwise = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-big",
      },
    },
    matchup = { -- It is in lua/packs/editor
      enable = true,
    },
  })

  require("nvim-treesitter.install").prefer_git = true

  _G.__nvim_treesitter_setup_done = true
end

function M.hlargs()
  require("hlargs").setup()
end

function M.context()
  require("treesitter-context").setup({
    enable = true,
    throttle = true,
  })
end

function M.treesj_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "<localleader>j", function()
    require("treesj").toggle()
  end, "Split or Join code block with autodetect")

  keymap("n", "<localleader>h", function()
    require("treesj").join()
  end, "Join code block")

  keymap("n", "<localleader>s", function()
    require("treesj").split()
  end, "Split code block")
end

function M.treesj()
  require("treesj").setup({
    use_default_keymaps = false,
  })
end

function M.refactoring()
  require("refactoring").setup({})
end

function M.surf_setup()
  local keymap = require("utils.keymap.presets").mode_only("n", { silent = true })
  local keymap_expr = require("utils.keymap.presets").mode_only("n", { silent = true, expr = true })
  local keymap_visual = require("utils.keymap.presets").mode_only("x", { silent = true })

  _G.STSSwapUpNormal_Dot = function()
    require("syntax-tree-surfer").move("n", true)
  end

  _G.STSSwapDownNormal_Dot = function()
    require("syntax-tree-surfer").move("n", false)
  end

  keymap_expr("<A-j>", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"

    return "g@l"
  end, "Move Current Node Down")

  keymap_expr("<A-k>", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"

    return "g@l"
  end, "Move Current Node Up")

  keymap("vx", function()
    require("syntax-tree-surfer").select()
  end, "Select Master Node")

  keymap("vn", function()
    require("syntax-tree-surfer").select_current_node()
  end, "Select Current Node")

  keymap("<A-p>", function()
    require("syntax-tree-surfer").go_to_top_node_and_execute_commands(false, {
      "normal! O",
      "normal! O",
      "startinsert",
    })
  end, "Let's brain power'")

  keymap_visual("<A-j>", function()
    require("syntax-tree-surfer").surf("next", "visual", true)
  end, "Surf Down")

  keymap_visual("<A-k>", function()
    require("syntax-tree-surfer").surf("prev", "visual", true)
  end, "Surf Up")

  keymap_visual("H", function()
    require("syntax-tree-surfer").surf("parent", "visual")
  end, "Select Parent Node")

  keymap_visual("J", function()
    require("syntax-tree-surfer").surf("next", "visual")
  end, "Select Next Node")

  keymap_visual("K", function()
    require("syntax-tree-surfer").surf("prev", "visual")
  end, "Select Previous Node")

  keymap_visual("L", function()
    require("syntax-tree-surfer").surf("child", "visual")
  end, "Select Child Node")
end

return M
