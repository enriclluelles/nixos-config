
local api = vim.api
api.nvim_create_autocmd("LspAttach", {
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


local lspconfig = require('lspconfig')

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
