let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

set number
set relativenumber
set tabstop=4
set autoindent
set softtabstop=4
set expandtab
set shiftwidth=4
set background=dark
set completeopt+=preview

let mapleader=" "
noremap <leader>t :Lexplore<CR>
noremap <leader>y "+y
noremap <leader>ff :Telescope find_files<CR>
noremap <leader>fg :Telescope live_grep<CR>
noremap <leader>fb :Telescope buffers<CR>
noremap <leader>fh :Telescope help_tags<CR>

noremap <leader>s :vsplit<CR>
noremap <leader>S :split<CR>

noremap <leader>dd :lua require"dapui".toggle()<CR>
noremap <leader>db :DapToggleBreakpoint<CR>
noremap <leader>dn :DapStepOver<CR>
noremap <leader>di :DapStepInto<CR>
noremap <leader>dc :DapTerminate<CR>
noremap <leader>ds :DapContinue<CR>


lua << EOF

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint(bufnr, true)
    end
  end
})

require "lspconfig".rust_analyzer.setup ({})
require "lspconfig".clangd.setup ({})
require "lspconfig".rust_analyzer.setup ({})
require "lspconfig".clangd.setup({})
require "lspconfig".pyright.setup({})
require "lspconfig".lua_ls.setup({})
require "lspconfig".glslls.setup({})
require "lspconfig".nil_ls.setup({})
require "lspconfig".emmet_ls.setup({})
require "lspconfig".tsserver.setup({})

local cmp = require 'cmp'
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<C-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },
    -- Installed sources:
    sources = {
        { name = 'path' },                                       -- file paths
        { name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
        { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
        { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer',                 keyword_length = 2 }, -- source current buffer
        { name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
        { name = 'calc' },                                       -- source for math calculation
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
  }
)

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '󰛨' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

require'telescope'.setup({defaults = {sorting_strategy="ascending"}})

EOF

noremap gR :lua vim.lsp.buf.references()<CR>
noremap gr :lua vim.lsp.buf.rename()<CR>
noremap gd :lua vim.lsp.buf.definition()<CR>
noremap gi :lua vim.lsp.buf.implementation()<CR>
noremap gD :lua vim.lsp.buf.declaration()<CR>
noremap gc :lua vim.lsp.buf.code_action()<CR>
noremap K  :lua vim.lsp.buf.hover()<CR>
noremap gf :lua vim.lsp.buf.format()<CR>
noremap gs :lua vim.lsp.buf.signature_help()<CR>
noremap <leader>e :lua vim.diagnostic.open_float()<CR>

autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascriptreact setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType vim setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescriptreact setlocal shiftwidth=2 softtabstop=2 expandtab

set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

set nofoldenable
set foldmethod=indent

colorscheme habamax
hi NonText ctermbg=black ctermfg=gray
