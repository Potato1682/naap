local M = {}

local utils = require("utils.lsp")

function M.common_on_attach(client, bufnr)
	local keymap = require("utils.keymap").omit("append", "n", "", { buffer = bufnr })
	local keymap_expr = require("utils.keymap").omit("append", "n", "", { buffer = bufnr, expr = true })

	local command = require("utils.command").current_buf_command

	local cap = client.server_capabilities

	if cap.hoverProvider then
		keymap("K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()

			if not winid then
				vim.lsp.buf.hover()
			end
		end, "Hover")
	end

	if cap.code_action or cap.codeActionProvider then
		keymap("<leader>la", function()
			vim.cmd("CodeActionMenu")
		end, "Code Action")
	end

	if cap.rename or cap.renameProvider then
		keymap_expr("gr", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, "Rename")
	end

	if cap.signature_help or cap.signatureHelpProvider then
		command("LspSignatureHelp", function()
			vim.lsp.buf.signature_help()
		end)
	end

	if cap.goto_definition or cap.definitionProvider then
		command("LspDefinition", function()
			vim.cmd("Glance definitions")
		end, "Go To Defenition")

		keymap("gd", function()
			vim.cmd("Glance definitions")
		end, "Go To Definition")
	end

	if cap.declaration or cap.declarationProvider then
		command("LspDeclaration", function()
			vim.lsp.buf.declaration()
		end, "Go To Declaration")

		keymap("gC", function()
			vim.lsp.buf.declaration()
		end, "Go To Declaration")
	end

	if cap.type_definition or cap.typeDefinitionProvider then
		command("LspTypeDefinition", function()
			vim.cmd("Glance type_definitions")
		end, "Go To Type Definition")

		keymap("go", function()
			vim.cmd("Glance type_definitions")
		end, "Go To Type Definition")
	end

	if cap.implementation or cap.implementationProvider then
		command("LspImplementation", function()
			vim.cmd("Glance implementations")
		end, "Go To Implementation")

		keymap("gI", function()
			vim.cmd("Glance implementations")
		end, "Go To Implementation")
	end

	if cap.find_references or cap.referencesProvider then
		command("LspReferences", function()
			vim.cmd("Glance references")
		end, "Go To References")

		keymap("gR", function()
			vim.cmd("Glance references")
		end, "Go To References")

		keymap("<a-n>", function()
			require("illuminate").next_reference({ wrap = true })
		end, "Next Reference")
		keymap("<a-p>", function()
			require("illuminate").next_reference({ wrap = true, reverse = true })
		end, "Previous Reference")
	end

	if cap.document_symbol or cap.documentSymbolProvider then
		command("LspDocumentSymbol", function()
			require("telescope.builtin").lsp_document_symbols()
		end, "Document Symbol")

		keymap("<leader>lsd", function()
			require("telescope.builtin").lsp_document_symbols()
		end, "Document Symbol")

		local ok, navic = pcall(require, "nvim-navic")

		if ok and client.config.name ~= "null-ls" then
			navic.attach(client, bufnr)
		end
	end

	if cap.workspace_symbol or cap.workspaceSymbolProvider then
		command(
			"LspWorkspaceSymbol",
			function(args)
				if args.args == "" then
					require("telescope.builtin").lsp_workspace_symbols()
				else
					vim.lsp.buf.workspace_symbol(args.args)
				end
			end,
			"Workspace Symbol",
			{
				nargs = "*",
			}
		)

		command("LspAllWorkspaceSymbol", function()
			require("telescope.builtin").lsp_dynamic_workspace_symbols()
		end, "All Workspace Symbol")

		keymap("<leader>lsw", function()
			require("telescope.builtin").lsp_workspace_symbols()
		end, "Workspace Symbol")

		keymap("<leader>lsW", function()
			require("telescope.builtin").lsp_dynamic_workspace_symbols()
		end, "All Workspace Symbol")
	end

	if cap.call_hierarchy or cap.callHierarchyProvider then
		command("LspIncomingCalls", function()
			require("telescope.builtin").lsp_incoming_calls()
		end, "Incoming Calls")

		command("LspOutgoingCalls", function()
			require("telescope.builtin").lsp_outgoing_calls()
		end, "Outgoing Calls")

		keymap("<leader>lci", function()
			require("telescope.builtin").lsp_incoming_calls()
		end, "Incoming Calls")

		keymap("<leader>lco", function()
			require("telescope.builtin").lsp_outgoing_calls()
		end, "Outgoing Calls")
	end

	if cap.code_lens or cap.codeLensProvider then
		local group = vim.api.nvim_create_augroup("codelens", {})

		vim.api.nvim_create_autocmd({ "TextChanged" }, {
			group = group,
			buffer = 0,
			callback = function()
				vim.lsp.codelens.refresh()
			end,
		})

		command("LspCodeLensRun", function()
			vim.lsp.codelens.run()
		end, "Run CodeLens")

		keymap("<leader>ll", function()
			vim.lsp.codelens.run()
		end, "Run CodeLens")
	end

	command("LspWorkspaceFolders", function()
		utils.list_workspace_folders()
	end, "Workspace Folders")

	command("LspAddWorkspaceFolder", function(args)
		vim.lsp.buf.add_workspace_folder(args.args ~= "" and vim.fn.fnamemodify(args.args, ":p"))
	end, "Add Workspace Folder", { nargs = "?", complete = "dir" })

	command(
		"LspRemoveWorkspaceFolder",
		function(args)
			vim.lsp.buf.remove_workspace_folder(unpack(args.fargs))
		end,
		"Remove Workspace Folder",
		{
			nargs = "?",
			complete = function()
				return vim.lsp.buf.list_workspace_folders()
			end,
		}
	)

	keymap("<leader>lwf", function()
		utils.list_workspace_folders()
	end, "Workspace Folders")

	keymap("<leader>lwa", function()
		vim.lsp.buf.add_workspace_folder()
	end, "Add Workspace Folder")

	keymap("<leader>lwr", function()
		vim.lsp.buf.remove_workspace_folder()
	end, "Remove Workspace Folder")

	command("LspLog", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()", "LSP Log")

	if client.supports_method("textDocument/formatting") then
		require("lsp-format").setup()

		require("lsp-format").on_attach(client)

		vim.cmd("cabbrev wq execute 'Format sync' <bar> wq")

		keymap("<leader>lf", function()
			require("lsp-format").format()
		end, "Format")
	end

	command("IlluminationDisable", "", "'command not found' workaround", { nargs = 0, bang = true })
	require("illuminate").on_attach(client)

	require("lsp-inlayhints").on_attach(client, bufnr)
end

function M.without_server_formatting(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	M.common_on_attach(client, bufnr)
end

return M
