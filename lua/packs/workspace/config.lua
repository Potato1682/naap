local M = {}

function M.remember()
  require("remember").setup {}
end

function M.persisted()
  require("persisted").setup {
    autosave = O.sessions.autosave,
    autoload = O.sessions.autoload,
    allowed_dirs = O.sessions.allowed_dirs,
    ignored_dirs = O.sessions.ignored_dirs,
    use_git_branch = true
  }
end

return M
