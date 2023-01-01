local keymap = require("utils.keymap").keymap

-- LSP keymap can be used BEFORE attach
keymap("n", "<leader>lI", function()
	vim.cmd("LspInfo")
end, "LSP Information", { silent = true })
