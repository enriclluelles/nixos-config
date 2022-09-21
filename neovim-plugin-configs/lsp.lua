require'lspconfig'.solargraph.setup{
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      useBundler = true
    }
  }
}
