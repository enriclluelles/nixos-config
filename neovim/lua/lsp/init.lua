local u = require("utils")
local lsp = vim.lsp

local border_opts = { border = "rounded", focusable = false }
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = true,
  signs = { active = signs },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = border_opts,
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)

local lsp_formatting = function(bufnr)
  lsp.buf.format({ bufnr = bufnr })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    --    if client.server_capabilities.completionProvider then
    --      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    --    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end
    if client.supports_method("textDocument/formatting") then
      u.buf_command(bufnr, "LspFormatting", function()
        lsp_formatting(bufnr)
      end)

      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        command = "LspFormatting",
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
--
--
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local ts_utils = require("nvim-lsp-ts-utils")
local b = null_ls.builtins

local with_root_file = function(...)
  local files = { ... }
  return function(utils)
    return utils.root_has_file(files)
  end
end

local s = {}

-- pairs of lsp server names and configs

s["tsserver"] = {
  root_dir = lspconfig.util.root_pattern("package.json"),
  init_options = ts_utils.init_options,
  on_attach = function(client, bufnr)
    ts_utils.setup({
      -- debug = true,
      auto_inlay_hints = false,
      import_all_scan_buffers = 100,
      update_imports_on_move = true,
      -- filter out dumb module warning
      filter_out_diagnostics_by_code = { 80001 },
    })
    ts_utils.setup_client(client)

    u.buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
    u.buf_map(bufnr, "n", "gr", ":TSLspRenameFile<CR>")
    u.buf_map(bufnr, "n", "gI", ":TSLspImportAll<CR>")
  end,
}

s["eslint"] = {
  root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    format = {
      enable = true,
    },
  },
  handlers = {
    -- this error shows up occasionally when formatting
    -- formatting actually works, so this will supress it
    ["window/showMessageRequest"] = function(_, result)
      if result.message:find("ENOENT") then
        return vim.NIL
      end

      return vim.lsp.handlers["window/showMessageRequest"](nil, result)
    end,
  },
}

s["sorbet"] = {}

s["solargraph"] = {}

s["sumneko_lua"] = {
  settings = {
    Lua = {
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
      diagnostics = {
        globals = {
          "global",
          "vim",
          "use",
          "describe",
          "it",
          "assert",
          "before_each",
          "after_each",
        },
      },
    },
  },
}

s["terraformls"] = {}
s["terraform_lsp"] = {}

for server, config in pairs(s) do
  local c = config
  c["capabilities"] = capabilities
  lspconfig[server].setup(c)
end

null_ls.setup({
  debug = true,
  sources = {
    b.diagnostics.rubocop.with({
      condition = with_root_file(".rubocop.yml"),
      command = "bundle",
      args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" },
    }),
    b.diagnostics.semgrep.with({
      condition = with_root_file(".semgrep.yml"),
    }),

    b.formatting.trim_whitespace.with({
      filetypes = { "tmux", "zsh" },
    }),
    b.formatting.rubocop.with({
      condition = with_root_file(".rubocop.yml"),
      command = "bundle",
      args = { "exec", "rubocop", "--auto-correct", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
    }),

    -- b.formatting.shfmt,
    -- b.formatting.stylua,
    -- b.formatting.terraform_fmt,
  },
})
