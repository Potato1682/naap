local M = {}

local utils = require("utils.lsp")

function M.common_on_attach(client, bufnr)
  local buf_keymap = function(mode, key, action, desc)
    require("utils.keymap").keymap(mode, key, action, desc, {
      buffer = true
    })
  end

  local command = require("utils.command").current_buf_command

  local cap

  if vim.fn.has("nvim-0.8.0") == 1 then
    cap = client.server_capabilities
  else
    cap = client.resolved_capabilities
  end

  if cap.code_action or cap.codeActionProvider then
    buf_keymap("n", "<leader>la", function()
      vim.cmd("CodeActionMenu")
    end, "Code Action")
  end

  if cap.rename or cap.renameProvider then
    command("LspRename", function(args)
      vim.lsp.buf.rename(args.args == "" and nil or args.args)
    end, "Rename", {
      nargs = "*",
      complete = function()
        return vim.fn.expand("<cword>")
      end
    })

    buf_keymap("n", "gr", function()
      vim.lsp.buf.rename()
    end, "Rename")
  end

  if cap.signature_help or cap.signatureHelpProvider then
    command("LspSignatureHelp", function()
      vim.lsp.buf.signature_help()
    end)
  end

  if cap.goto_definition or cap.definitionProvider then
    command("LspDefinition", function()
      require("telescope.builtin").lsp_definitions()
    end, "Defenition")
    command("LspPreviewDefinition", function()
      require("goto-preview").goto_preview_definition()
    end, "Preview Definition")

    buf_keymap("n", "gD", function()
      require("telescope.builtin").lsp_definitions()
    end, "Definition")
    buf_keymap("n", "gpD", function()
      require("goto-preview").goto_preview_definition()
    end, "Preview Definition")
  end

  if cap.declaration or cap.declarationProvider then
    command("LspDeclaration", function()
      vim.lsp.buf.declaration()
    end, "Declaration")

    buf_keymap("n", "gC", function()
      vim.lsp.buf.declaration()
    end, "Declaration")
  end

  if cap.type_definition or cap.typeDefinitionProvider then
    command("LspTypeDefinition", function()
      require("telescope.builtin").lsp_type_definitions()
    end, "Type Definition")

    buf_keymap("n", "go", function()
      require("telescope.builtin").lsp_type_definitions()
    end, "Type Definition")
  end

  if cap.implementation or cap.implementationProvider then
    command("LspImplementation", function()
      require("telescope.builtin").lsp_implementations()
    end, "Implementation")
    command("LspPreviewImplementation", function()
      require("goto-preview").goto_preview_implementation()
    end, "Preview Implementation")

    buf_keymap("n", "gI", function()
      require("telescope.builtin").lsp_implementations()
    end, "Implementation")
    buf_keymap("n", "gpI", function()
      require("goto-preview").goto_preview_implementation()
    end, "Preview Implementation")
  end

  if cap.find_references or cap.referencesProvider then
    command("LspReferences", function()
      require("telescope.builtin").lsp_references()
    end, "References")
    command("LspPreviewReferences", function()
      require("goto-preview").goto_preview_references()
    end, "Preview References")

    buf_keymap("n", "gR", function()
      require("telescope.builtin").lsp_references()
    end, "References")
    buf_keymap("n", "gpR", function()
      require("goto-preview").goto_preview_references()
    end, "Preview References")

    buf_keymap("n", "<a-n>", function()
      require("illuminate").next_reference({ wrap = true })
    end, "Next Reference")
    buf_keymap("n", "<a-p>", function()
      require("illuminate").next_reference({ wrap = true, reverse = true })
    end, "Previous Reference")
  end

  if cap.document_symbol or cap.documentSymbolProvider then
    command("LspDocumentSymbol", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Document Symbol")

    buf_keymap("n", "<leader>lsd", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Document Symbol")
  end

  if cap.workspace_symbol or cap.workspaceSymbolProvider then
    command("LspWorkspaceSymbol", function(args)
      if args.args == "" then
        require("telescope.builtin").lsp_workspace_symbols()
      else
        vim.lsp.buf.workspace_symbol(args.args)
      end
    end, "Workspace Symbol", {
      nargs = "*"
    })

    command("LspAllWorkspaceSymbol", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, "All Workspace Symbol")

    buf_keymap("n", "<leader>lsw", function()
      require("telescope.builtin").lsp_workspace_symbols()
    end, "Workspace Symbol")

    buf_keymap("n", "<leader>lsW", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, "All Workspace Symbol")
  end

  if cap.call_hierarchy or cap.callHierarchyProvider then
    command("LspIncomingCalls", function()
      vim.lsp.buf.incoming_calls()
    end, "Incoming Calls")

    command("LspOutgoingCalls", function()
      vim.lsp.buf.outgoing_calls()
    end, "Outgoing Calls")

    buf_keymap("n", "<leader>lci", function()
      vim.lsp.buf.incoming_calls()
    end, "Incoming Calls")

    buf_keymap("n", "<leader>lco", function()
      vim.lsp.buf.outgoing_calls()
    end, "Outgoing Calls")
  end

  if cap.code_lens or cap.codeLensProvider then
    vim.api.nvim_create_autocmd({ "TextChanged" }, {
      buffer = 0,
      callback = function()
        vim.lsp.codelens.refresh()
      end
    })

    command("LspCodeLensRun", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")

    buf_keymap("n", "<leader>ll", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")
  end

  command("LspWorkspaceFolders", function()
    utils.list_workspace_folders()
  end, "Workspace Folders")

  if cap.workspace_folder_properties.supported then
    command("LspAddWorkspaceFolder", function(args)
      vim.lsp.buf.add_workspace_folder(args.args ~= "" and vim.fn.fnamemodify(args.args, ":p"))
    end, "Add Workspace Folder", { nargs = "?", complete = "dir" })

    command("LspRemoveWorkspaceFolder", function(args)
      vim.lsp.buf.remove_workspace_folder(unpack(args.fargs))
    end, "Remove Workspace Folder", {
      nargs = "?",
      complete = function()
        return vim.lsp.buf.list_workspace_folders()
      end
    })

    buf_keymap("n", "<leader>lwf", function()
      utils.list_workspace_folders()
    end, "Workspace Folders")

    buf_keymap("n", "<leader>lwa", function()
      vim.lsp.buf.add_workspace_folder()
    end, "Add Workspace Folder")

    buf_keymap("n", "<leader>lwr", function()
      vim.lsp.buf.remove_workspace_folder()
    end, "Remove Workspace Folder")
  end

  command("LspLog", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()", "LSP Log")

  if client.supports_method "textDocument/formatting" then
    require("lsp-format").on_attach(client)

    vim.cmd("cabbrev wq execute 'Format sync' <bar> wq")

    buf_keymap("n", "<leader>lf", function()
      require("lsp-format").format()
    end, "Format")
  end

  command("IlluminationDisable", "", "'command not found' workaround", { nargs = 0, bang = true })
  require("illuminate").on_attach(client)

  require("inlay-hints").on_attach(client, bufnr)
end

function M.without_server_formatting(client, bufnr)
  (client.server_capabilities or client.resolved_capabilities).document_formatting = false
  (client.server_capabilities or client.resolved_capabilities).document_range_formatting = false
  (client.server_capabilities or client.resolved_capabilities).documentFormattingProvider = false
  (client.server_capabilities or client.resolved_capabilities).documentRangeFormattingProvider = false

  M.common_on_attach(client, bufnr)
end

return M
