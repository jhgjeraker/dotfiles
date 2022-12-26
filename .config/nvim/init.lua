-------------------------------------------------------------------------------                                  Setup
-- Leader Key
vim.g.mapleader = ','

-- Python Hosts
-- The following env should have the `neovim` package installed.
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/home/kepler/.pyenv/versions/neovim-py39/bin/python'

-------------------------------------------------------------------------------
--                                  Packer
local packer = require("packer")
local use = packer.use

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float {border = "single"}
        end
    },
    git = {
        clone_timeout = 60 -- Timeout, in seconds, for git clones
    }
}

local P = packer.startup(
    function()
        -- Packer can manage itself.
        use 'wbthomason/packer.nvim'

        -- Color Schemes
        -- use 'arcticicestudio/nord-vim'
        use {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
        use 'logico/typewriter-vim'
        use 'Everblush/everblush.nvim'

        -- Status Line
        use {
            'hoob3rt/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }

        -- Focus Mode
        use 'junegunn/goyo.vim'
        use 'junegunn/limelight.vim'

        -- fzf
        use 'junegunn/fzf'
        use 'junegunn/fzf.vim'

        -- LSP
        use 'neovim/nvim-lspconfig'
        use 'williamboman/nvim-lsp-installer'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/cmp-vsnip'
        use 'hrsh7th/vim-vsnip'
        use 'hrsh7th/vim-vsnip-integ'

        -- Extra linter in addition to LSP
        use 'mfussenegger/nvim-lint'

        -- Treesitter
        -- Used for code context.
        use 'nvim-treesitter/nvim-treesitter'

        -- Folding
        use 'tmhedberg/SimpylFold'
        use 'Konfekt/FastFold'

        -- Auto-pairing of brackets
        use 'jiangmiao/auto-pairs'

        -- proper python indenting
        use 'Vimjas/vim-python-pep8-indent'

        -- Floating terminal
        use 'numtostr/FTerm.nvim'

        -- Show Git blame lines
        use 'f-person/git-blame.nvim'

        -- CheatSheet
        use {
            'sudormrfbin/cheatsheet.nvim',
            requires = {
                {'nvim-telescope/telescope.nvim'},
                {'nvim-lua/popup.nvim'},
                {'nvim-lua/plenary.nvim'},
            }
        }

        -- diffview.nvim
        use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
        use 'kyazdani42/nvim-web-devicons'
    end
)

local H = {}


-------------------------------------------------------------------------------
--                                  Themes
--
-- Gruvbox
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- EverBlush
-- local everblush = require('everblush')
-- everblush.setup({ nvim_tree = { contrast = false } })

-- Adds relative path to file in status line.
vim.cmd "set statusline+=%{expand('%:~:.')}"

require('lualine').setup({
    options = {
        theme = 'gruvbox',
    },
})


-------------------------------------------------------------------------------
--                                   General
-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- Indenting
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Scroll-Off Buffer
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

-- Row Ruler
vim.o.ruler = true
vim.o.cursorline = true

-- Line Numbering
vim.o.number = true
vim.o.relativenumber = true

-- Split
vim.o.splitbelow = true
vim.o.splitright = true

-- Folding
vim.o.foldlevel = 10

-- golang: 4 spaces as tab
vim.cmd 'au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4'

-- protobuf: 2 spaces
vim.cmd 'autocmd FileType proto setlocal shiftwidth=2 softtabstop=2 expandtab'

-- rst: 3 spaces
vim.cmd 'autocmd FileType rst setlocal shiftwidth=3 softtabstop=3 expandtab'

-- html / css: 2 spaces
vim.cmd 'autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab'
vim.cmd 'autocmd FileType css setlocal shiftwidth=2 softtabstop=2 expandtab'

-- terraform: 2 spaces
vim.cmd 'autocmd FileType tf setlocal shiftwidth=2 softtabstop=2 expandtab'

-- csv: 4 spaces as tab
vim.cmd 'au BufNewFile,BufRead *.csv setlocal noet ts=4 sw=4 sts=4'

-- html: 2 spaces as tab
vim.cmd 'au BufNewFile,BufRead *.html setlocal noet ts=2 sw=2 sts=2'

-- css: 4 spaces as tab
vim.cmd 'autocmd FileType css setlocal shiftwidth=4 softtabstop=4 expandtab'

-------------------------------------------------------------------------------
--                                  Keybinds
function H.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Refresh File
H.map('n', '<Leader>e', ':edit<cr>')

-- Press enter to reset search highlighting.
H.map('n', '<ESC>', ':nohlsearch<CR>')

-- Jump Movement
-- H.map('n', '<S-j>', '5j')
-- H.map('n', '<S-k>', '5k')

-- Tabs
-- H.map('n', '<F11>', ':tabprevious<CR>')
-- H.map('n', '<F12>', ':tabnext<CR>')

-- Clipboard
H.map('', '<leader>y', '"+y')
H.map('', '<leader>p', '"+p')

-- Splits
-- H.map('n', '<C-J>', '<C-W><C-J>')
-- H.map('n', '<C-K>', '<C-W><C-K>')
-- H.map('n', '<C-L>', '<C-W><C-L>')
-- H.map('n', '<C-H>', '<C-W><C-H>')

-- LSP
H.map('n', '<leader>n', ':lua vim.diagnostic.goto_next()<cr>')
H.map('n', '<leader>N', ':lua vim.diagnostic.goto_prev()<cr>')

H.map('n', '<leader>g', ':Goyo 80%x80%<CR>')
vim.cmd 'autocmd! User GoyoEnter Limelight'
vim.cmd 'autocmd! User GoyoLeave Limelight!'


-------------------------------------------------------------------------------
--                                  fzf
--
vim.g.rtp = '~/.fzf'

-- keybinds
H.map('n', '<leader>t', ':Files<CR>')
H.map('n', '<leader>T', ':Files ~<CR>')
H.map('n', '<leader>r', ':Rg<CR>')
H.map('n', '<leader>d', ':tree -d<CR>')

vim.g.fzf_action = {
    ['ctrl-t'] = 'tab split',
    ['ctrl-x'] = 'split',
    ['ctrl-v'] = 'vsplit',
    ['ctrl-y'] = ':r !echo',
}


-------------------------------------------------------------------------------
--                              nvim-cmp
--
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    }
})

-------------------------------------------------------------------------------
--                              LSP-config
--
require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- HTML server
require('lspconfig')['html'].setup {
    capabilities = capabilities,
    cmd = { "vscode-html-language-server", "--stdio" },
    settings = {
        html = {
            format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = 'auto',
            },
            hover = {
                documentation = true,
                references = true,
            },
        },
    },
}

require'lspconfig'.cssls.setup {
    capabilities = capabilities,
}

require'lspconfig'.gopls.setup {
    capabilities = capabilities,
}

require'lspconfig'.golangci_lint_ls.setup {
    capabilities = capabilities,
}

require'lspconfig'.pyright.setup{
    capabilities = capabilities,
}

require'lspconfig'.sumneko_lua.setup{
    capabilities = capabilities,
}

require'lspconfig'.jsonls.setup{
    capabilities = capabilities,
}

require'lspconfig'.tsserver.setup{
    capabilities = capabilities,
}

require'lspconfig'.clangd.setup{
    capabilities = capabilities,
}


local opts = { noremap=true, silent=true }
H.map('n', 'mo', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
H.map('n', 'md', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
H.map('n', 'mD', "<cmd>tab split | lua vim.lsp.buf.definition()<CR>")
H.map('n', 'mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
H.map('n', 'mi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- H.map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
H.map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
H.map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
H.map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
H.map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
H.map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
H.map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
H.map('n', 'mr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
H.map('n', 'me', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
H.map('n', 'mE', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
H.map('n', '[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
H.map('n', ']', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
H.map('n', 'mf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)


-------------------------------------------------------------------------------
--                              TreeSitter
--
require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
    	    init_selection = "gnn",
    	    node_incremental = "gnn",
    	    scope_incremental = "gnc",
    	    node_decremental = "gnd",
        },
    },
    indent = {
        enable = false
    },
})

vim.api.nvim_exec([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
]], false)


-------------------------------------------------------------------------------
--                              nvim-lint
--
require('lint').linters_by_ft = {
    python = {'flake8',}
}

vim.cmd "autocmd BufWritePost *.py lua require('lint').try_lint()"


-------------------------------------------------------------------------------
--                          Python PEP8 Indent
--
vim.g.python_pep8_indent_multiline_string = -1


-------------------------------------------------------------------------------
--                               FTerm
--
require'FTerm'.setup({
    dimensions  = {
        height = 0.6,
        width = 0.6,
        x = 0.5,
        y = 0.5
    },
    border = 'single' -- or 'double'
})
local opts = { noremap = true, silent = true }
H.map('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>', opts)
H.map('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)

---- own
H.map('v', 'mm', '<cmd>:call Lookup()<CR>', opts)

-- docs
H.map('n', '<leader>bba', '<cmd>:cd ~/bb-box/docs<CR>')


-------------------------------------------------------------------------------
--                               Cheatsheet
--
require("cheatsheet").setup({
    bundled_cheatsheets = {
        -- only show the default cheatsheet
        enabled = { "default" },
    },
})

H.map('n', '<Leader>c', ':Cheatsheet<CR>')

