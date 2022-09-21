vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end
  end,
})

lspconfig = require('lspconfig')

lspconfig.solargraph.setup{
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      useBundler = true
    }
  }
}

lspconfig.tsserver.setup{}
lspconfig.sumneko_lua.setup{}

if resolved_capabilities.goto_definition == true then
    api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

if resolved_capabilities.document_formatting == true then
    api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- Add this <leader> bound mapping so formatting the entire document is easier.
    map("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

