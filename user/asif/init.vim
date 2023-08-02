let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_winsize = 25

set number
set relativenumber
set tabstop=4
set autoindent
set softtabstop=4
set expandtab
set shiftwidth=4
set background=dark

let mapleader=" "
noremap <leader>t :NvimTreeToggle<CR>
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

lua<<EOF
require'rose-pine'.setup({
  highlight_groups = {
    LspInlayHint = { bg = 'text', fg = 'gold', blend = 20 }
  },
  disable_italics = true
})
require'mason'.setup {
    ensure_installed = { "emmet-ls", "clangd", "tsserver", "pyright", "codelldb", "lua-language-server" }
}
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
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    }
}
require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint(bufnr, true)
    end
  end
})
require "gitsigns".setup{}
--require('rust-tools').setup({})
require "lspconfig".rust_analyzer.setup ({})
require "lspconfig".clangd.setup({})
require "lspconfig".pyright.setup({})
require "lspconfig".lua_ls.setup({})
require "lspconfig".glslls.setup({})
require "lspconfig".nil_ls.setup({})
require "lspconfig".tsserver.setup({
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        }
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
  }
)

require'toggleterm'.setup{}
require'nvim-tree'.setup{}
require'neogit'.setup{}
require'lualine'.setup{}

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

EOF

noremap gR :lua vim.lsp.buf.references()<CR>
noremap gr :lua vim.lsp.buf.rename()<CR>
noremap gd :lua vim.lsp.buf.definition()<CR>
noremap gi :lua vim.lsp.buf.implementation()<CR>
noremap gD :lua vim.lsp.buf.declaration()<CR>
noremap gc :lua vim.lsp.buf.code_action()<CR>
noremap K  :Lspsaga hover_doc<CR>
noremap gh :Lspsaga lsp_finder<CR>
noremap gf :lua vim.lsp.buf.format()<CR>
noremap gs :lua vim.lsp.buf.signature_help()<CR>
noremap <leader>e :lua vim.diagnostic.open_float()<CR>
noremap <A-d> :Lspsaga toggle_floaterm<CR>
tnoremap <A-d> <c-\><c-n>:Lspsaga toggle_floaterm<CR>
" set
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

lua<<EOF
-- CodeLLDB rust setup
local extension_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"
local codelldb_path = vim.fn.stdpath "data" .. "/mason/bin/codelldb"
local os = vim.loop.os_uname().sysname
local liblldb_path = extension_path .. (os == "Linux" and 'lldb/lib/liblldb.so' or "lldb/lib/liblldb.dylib")

local rt = require("rust-tools")
rt.setup({
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
    },
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    }
})
local dap = require('dap')
local codelldb_port = '13000'
dap.adapters.codelldb = {
    type = 'server',
    port = codelldb_port,
    executable = {
        command = codelldb_path,
        args = { "--port", codelldb_port },
        -- On windows you may have to uncomment this:
        -- detached = false,
    }
}
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
            },
        },
    },
    require("dapui").setup()
}

vim.diagnostic.config({
    virtual_text = false,
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

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '>', right = '<' },
        section_separators = { left = ':', right = '=:' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
EOF

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

colorscheme rose-pine
