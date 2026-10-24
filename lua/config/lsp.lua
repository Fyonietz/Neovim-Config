-- ================================================================================================
-- lsp.lua — diagnostics, LSP keymaps and language server definitions
-- ================================================================================================
-- Uses the Neovim 0.11+ vim.lsp.config()/vim.lsp.enable() API. nvim-lspconfig supplies the
-- individual server configurations; this file only overrides cmd/filetypes/root markers.
-- ================================================================================================

local augroup = vim.api.nvim_create_augroup("UserConfigLSP", {})

-- ------------------------------------------------------------------------------------------------
-- Diagnostics
-- ------------------------------------------------------------------------------------------------
local signs = {
  Error = "\u{f06a} ",
  Warn  = "\u{f071} ",
  Hint  = "\u{f0eb} ",
  Info  = "\u{f05a} ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "always", header = "", prefix = "" },
})

-- Rounded borders on floating LSP windows
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_open_floating_preview(contents, syntax, opts, ...)
end

-- ------------------------------------------------------------------------------------------------
-- Keymaps
-- ------------------------------------------------------------------------------------------------
-- Buffer-local maps, installed when a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,  opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,       opts)
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,  opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Global diagnostic navigation. These live under <leader>d because a bare `n` is remapped to a
-- centred search in keymaps.lua, which makes plain `nd` unreachable.
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev,  { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- ------------------------------------------------------------------------------------------------
-- Language servers
-- ------------------------------------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Zig
vim.lsp.config("zls", {
  cmd          = { vim.fn.expand("/opt/zls/zls") },
  filetypes    = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("zls")
-- vim.lsp.config("zigscient",{
--     cmd = {vim.fn.expand("/opt/zigscient/zigscient-x86_64-linux")},
--     filetypes = {"zig","zir"},
--       root_markers = { "zls.json", "build.zig", ".git" },
--       capabilities = capabilities,
-- })
-- vim.lsp.enable("zigscient")

--Assembly
vim.lsp.config("asm-lsp",{
    cmd = {vim.fn.expand("/usr/sbin/asm-lsp")},
    filetypes = {"asm","s","vasm"},
      capabilities = capabilities,
})
vim.lsp.enable("asm-lsp")
-- C#
vim.lsp.config("omnisharp", {
  cmd = {
    vim.fn.expand("~/.local/share/omnisharp/OmniSharp"),
    "--languageserver",
    "--hostPID",
    tostring(vim.fn.getpid()),
  },
  filetypes    = { "cs" },
  root_markers = { "*.sln", "*.csproj", ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("omnisharp")

-- Web
vim.lsp.config("html", {
  cmd          = { "vscode-html-language-server", "--stdio" },
  filetypes    = { "html" },
  root_markers = { ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("html")

vim.lsp.config("cssls", {
  cmd          = { "vscode-css-language-server", "--stdio" },
  filetypes    = { "css", "scss" },
  root_markers = { ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("cssls")

vim.lsp.config("ts_ls", {
  cmd          = { "typescript-language-server", "--stdio" },
  filetypes    = { "javascript", "typescript", "astro", "vue" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("ts_ls")

-- Angular is only started from an Angular project, so it is left disabled globally:
-- vim.lsp.config("angularls", { autostart = false })
