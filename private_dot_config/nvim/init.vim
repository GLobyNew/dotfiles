" Basic settings
syntax on
filetype plugin indent on
set clipboard=unnamedplus
set relativenumber
set termguicolors
" Go-specific indentation (Go uses tabs; you can adjust as desired)
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4

" Initialize plugins
call plug#begin('~/.config/nvim/plugged')

" Auto-closing of brackets, quotes, etc.
Plug 'windwp/nvim-autopairs'
" Colorscheme plugin
Plug 'folke/tokyonight.nvim'
" Autocompletion framework and sources
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
" Snippet engine (required by nvim-cmp)
Plug 'L3MON4D3/LuaSnip'
" LSP configuration helper (optional but handy for Go LSP)
Plug 'neovim/nvim-lspconfig'

call plug#end()

" Set the colorscheme
colorscheme tokyonight

" Lua configuration block for plugin setup
lua << EOF
-- Setup nvim-autopairs (for auto-closing brackets, etc.)
require('nvim-autopairs').setup{}

-- Setup nvim-cmp for autocompletion
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      -- For LuaSnip users.
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Setup LSP for Go (using gopls)
local nvim_lsp = require('lspconfig')
nvim_lsp.gopls.setup{
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
EOF

