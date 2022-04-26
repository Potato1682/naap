local default = require("user-config.defaults")
local custom = require("user-config.custom")

_G.O = vim.tbl_deep_extend("force", default, custom)

return _G.O

