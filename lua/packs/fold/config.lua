local M = {}

function M.cycle_setup()
  local keymap = require("utils.keymap.presets").mode_only("n")

  keymap("<CR>", function()
    require("fold-cycle").open()
  end, "Open Folding")
  keymap("<BS>", function()
    require("fold-cycle").close()
  end, "Close Folding")
  keymap("zC", function()
    require("fold-cycle").close_all()
  end, "Close All Folding")
end

function M.cycle()
  require("fold-cycle").setup()
end

function M.pretty()
  require("pretty-fold").setup {}
  require("pretty-fold.preview").setup {}
end

return M
