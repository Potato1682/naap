local abbrev = require("utils.abbreviation").abbrev

abbrev("c", "l", "lua")
abbrev("c", "lf", "luafile")
abbrev("c", "pc", "PackerCompile")
abbrev("c", "ps", "PackerSync")

for _, abbreviation in ipairs(O.editor.abbreviations) do
  abbrev(abbreviation.mode, abbreviation.lhs, abbreviation.rhs)
end
