local M = {}

local extensions = {}

function M.register_extension(extension)
	local ok, telescope = pcall(require, "telescope")

	if not ok then
		table.insert(extensions, extension)

		return
	end

	-- load directly if telescope has already loaded
	telescope.load_extension(extension)
end

function M.load_registered_extensions()
	local ok, telescope = pcall(require, "telescope")

	if not ok then
		error("Telescope is not loaded")
	end

	for _, extension in ipairs(extensions) do
		telescope.load_extension(extension)
	end

	extensions = {}
end

return M
