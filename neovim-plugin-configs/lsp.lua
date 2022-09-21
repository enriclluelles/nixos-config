
local api = vim.api
api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
	print("Attached" .. args)
end,
})

api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        print("Entered buffer " .. args.buf .. "!")
    end,
    desc = "Tell me when I enter a buffer",
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
