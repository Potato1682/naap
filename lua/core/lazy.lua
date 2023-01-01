vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*",
	callback = function()
		local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))

		if fsize == nil or fsize < 0 then
			fsize = 1
		end

		if fsize > 6 * 1024 * 1024 then
			vim.notify("Filesize is too large, disabling syntax highlighting", vim.log.levels.WARN, {
				title = "Lazy (core)",
			})

			vim.cmd("syntax off")
		end
	end,
})

local lazy_load = function()
	local disable_filetypes = {
		"packer",
		"TelescopePrompt",
		"csv",
		"txt",
	}

	local syntax_on = not vim.tbl_contains(disable_filetypes, vim.opt_local.filetype:get())

	if not syntax_on then
		vim.cmd("syntax manual")
	end
end

vim.defer_fn(function()
	vim.cmd("doautocmd User LoadLazyPlugin")
end, 30)

vim.api.nvim_create_autocmd("User LoadLazyPlugin", {
	callback = function()
		lazy_load()
	end,
})
