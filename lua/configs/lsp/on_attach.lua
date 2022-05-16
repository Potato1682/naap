local M = {}

function M.common_on_attach(client, bufnr)
  local buf_keymap = function(mode, key, action, desc)
    vim.keymap.set(mode, key, action, {
      buffer = true,
      desc = desc
    })
  end

  local command = function(name, command, desc, options)
    desc = desc or ""
    options = vim.tbl_deep_extend("force", options or {}, { desc = desc })

    vim.api.nvim_buf_create_user_command(0, name, command, options)
  end

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
      vim.lsp.buf.definition()
    end, "Defenition")
    command("LspPreviewDefinition", function()
      require("goto-preview").goto_preview_definition()
    end, "Preview Definition")

    buf_keymap("n", "gD", function()
      vim.lsp.buf.definition()
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
      vim.lsp.buf.type_definition()
    end, "Type Definition")

    buf_keymap("n", "go", function()
      vim.lsp.buf.type_definition()
    end, "Type Definition")
  end

  if cap.implementation or cap.implementationProvider then
    command("LspImplementation", function()
      vim.lsp.buf.implementation()
    end, "Implementation")
    command("LspPreviewImplementation", function()
      require("goto-preview").goto_preview_implementation()
    end, "Preview Implementation")

    buf_keymap("n", "gI", function()
      vim.lsp.buf.implementation()
    end, "Implementation")
    buf_keymap("n", "gpI", function()
      require("goto-preview").goto_preview_implementation()
    end, "Preview Implementation")
  end

  if cap.find_references or cap.referencesProvider then
    command("LspReferences", function()
      vim.lsp.buf.references()
    end, "References")
    command("LspPreviewReferences", function()
      require("goto-preview").goto_preview_references()
    end, "Preview References")

    buf_keymap("n", "gR", function()
      vim.lsp.buf.references()
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
      vim.lsp.buf.document_symbol()
    end, "Document Symbol")

    buf_keymap("n", "<leader>lsd", function()
      vim.lsp.buf.document_symbol()
    end, "Document Symbol")
  end

  if cap.workspace_symbol or cap.workspaceSymbolProvider then
    command("LspWorkspaceSymbol", function(args)
      vim.lsp.buf.workspace_symbol(args.args)
    end, "Workspace Symbol", {
      nargs = "*"
    })

    buf_keymap("n", "<leader>lsw", function()
      vim.lsp.buf.workspace_symbol()
    end, "Workspace Symbol")
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
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
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
    print(table.concat(vim.lsp.buf.list_workspace_folders(), "\n"))
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
      print(table.concat(vim.lsp.buf.list_workspace_folders(), "\n"))
    end, "Workspace Folders")

    buf_keymap("n", "<leader>lwa", function()
      vim.lsp.buf.add_workspace_folder()
    end, "Add Workspace Folder")

    buf_keymap("n", "<leader>lwr", function()
      vim.lsp.buf.remove_workspace_folder()
    end, "Remove Workspace Folder")
  end

  command("LspDiagnosticsNext", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")
  command("LspDiagNext", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")

  command("LspDiagnosticsPrev", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")
  command("LspDiagPrev", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")

  command("LspDiagnosticsLine", function()
    vim.diagnostic.show_line_diagnostics()
  end, "Show Line Diagnostics")
  command("LspDiagLine", function()
    vim.diagnostic.show_line_diagnostics()
  end, "Show Line Diagnostics")

  buf_keymap("n", "gla", function()
    vim.diagnostic.show_line_diagnostics()
  end, "Show Line Diagnostics")
  buf_keymap("n", "]a", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostics")
  buf_keymap("n", "[a", function()
    vim.diagnostic.goto_prev()
  end, "Previous Diagnostics")

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
  local cap

  if vim.fn.has("nvim-0.8.0") then
    cap = client.server_capabilities
  else
    cap = client.resolved_capabilities
  end

  cap.document_formatting = false
  cap.document_range_formatting = false
  cap.documentFormattingProvider = false
  cap.documentRangeFormattingProvider = false

  M.common_on_attach(client, bufnr)
end

return M
