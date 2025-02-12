vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.backup = false
vim.g.writebackup = false
vim.g.swapfile = false

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.opt.termguicolors = true
vim.o.background = 'light'
vim.cmd('colorscheme gruvbox')
vim.api.nvim_set_var('lightline', { colorscheme = 'gruvbox' })

local lspconfig = require('lspconfig')

function bufmap(buffer, mode, lhs, rhs)
  options = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, options)
end

local set_bindings = function(client, buffer)
  vim.api.nvim_buf_set_option(buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  bufmap(buffer, 'n', '<Leader>cX', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  bufmap(buffer, 'n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  bufmap(buffer, 'n', '<Leader>cf', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  bufmap(buffer, 'n', '<Leader>ci', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
  bufmap(buffer, 'n', '<Leader>cr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  bufmap(buffer, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  bufmap(buffer, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  bufmap(buffer, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  bufmap(buffer, 'n', 'gD', '<cmd>lua vim.lsp.buf.references()<CR>')
  bufmap(buffer, 'n', 'gI', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
  bufmap(buffer, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  bufmap(buffer, 'v', '<Leader>ca', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
end

local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
  'n',
  '<Leader>ff',
  ':Files<CR>',
  options
)

vim.api.nvim_set_keymap(
  'n',
  '<Leader>/',
  ':Rg<CR>',
  options
)

local debounce = { debounce_text_changes = 150 } 

lspconfig['tsserver'].setup({
  on_attach = function(client, buffer)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    set_bindings(client, buffer)
  end,
  flags = debounce,
})

lspconfig['denols'].setup({
  autostart = false,
  on_attach = set_bindings,
  flags = debounce,
})

local null_ls = require('null-ls')

null_ls.config({
  sources = {
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.rubocop,
  }
})

lspconfig['null-ls'].setup({
  on_attach = set_bindings,
  flags = debounce,
})
