local git = {}

git["lewis6991/gitsigns.nvim"] = {
	event = "BufReadPost",

	config = function()
		require("packs.git.config").gitsigns()
	end,
}

git["sindrets/diffview.nvim"] = {
	module = "diffview",

	cmd = {
		"DiffviewOpen",
		"DiffviewFileHistory",
	},

	config = function()
		require("packs.git.config").diffview()
	end,
}

git["TimUntersberger/neogit"] = {
	module = "neogit",

	setup = function()
		require("packs.git.config").neogit_setup()
	end,

	config = function()
		require("packs.git.config").neogit()
	end,
}

git["akinsho/git-conflict.nvim"] = {
	after = "gitsigns.nvim",
	keys = "<Plug>(git-conflict-",

	setup = function()
		require("packs.git.config").conflict_setup()
	end,

	config = function()
		require("packs.git.config").conflict()
	end,
}

git["pwntester/octo.nvim"] = {
	disable = vim.fn.executable("gh") == 0,

	cmd = "Octo",

	config = function()
		require("packs.git.config").octo()
	end,
}

return git
