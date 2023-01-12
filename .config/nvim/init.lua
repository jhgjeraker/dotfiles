-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        is_bootstrap = true
        vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

-------------------------------------------------------------------------------
--                                                                       Packer
--
require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    use { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- 'j-hui/fidget.nvim',

            -- Additional lua configuration, makes nvim stuff amazing
            'folke/neodev.nvim',
        },
    }

    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
    }

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'lewis6991/gitsigns.nvim'
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'kyazdani42/nvim-web-devicons'
    use 'f-person/git-blame.nvim'


    -- Aesthetics
    use {'ellisonleao/gruvbox.nvim', requires = {'rktjmp/lush.nvim'}}
    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

    -- General Functionality
    use 'jiangmiao/auto-pairs' -- Autocompletion of brackets
    use 'Vimjas/vim-python-pep8-indent' -- Python PEP 8 indent.
    use 'mfussenegger/nvim-lint' -- Linter to complement LSP.

    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
    local has_plugins, plugins = pcall(require, 'custom.plugins')
    if has_plugins then
        plugins(use)
    end

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})

-------------------------------------------------------------------------------
--                                                                   Aesthetics
--
-- Set colorscheme
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd [[colorscheme gruvbox]]

-- Set lualine as statusline (:help lualine.txt)
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = '|',
    section_separators = '',
  },
}

-------------------------------------------------------------------------------
--                                                             General Settings
--
-- See `:help vim.o`

vim.o.hlsearch = true           -- set highlight on search
vim.wo.number = true            -- line numbering
vim.o.relativenumber = true     -- relative line number
vim.o.mouse = 'a'               -- enable mouse mode
vim.o.breakindent = true
vim.o.undofile = true           -- save undo history to file
vim.o.ignorecase = true         -- case insensitive
vim.o.smartcase = true
vim.o.updatetime = 250          -- decrease update time
vim.wo.signcolumn = 'yes'       -- left-most column for git/diagnostics
vim.o.completeopt = 'menu,menuone,noinsert,noselect'

-- Set default indentation to 4 spaces unless overridden below.
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.cmd 'au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4' -- golang: 4 spaces as tab
vim.cmd 'autocmd FileType proto setlocal shiftwidth=2 softtabstop=2 expandtab' -- protobuf: 2 spaces
vim.cmd 'autocmd FileType rst setlocal shiftwidth=3 softtabstop=3 expandtab' -- rst: 3 spaces
vim.cmd 'autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab' -- html: 2 spaces
vim.cmd 'autocmd FileType tf setlocal shiftwidth=2 softtabstop=2 expandtab' -- terraform: 2 spaces
vim.cmd 'au BufNewFile,BufRead *.csv setlocal noet ts=4 sw=4 sts=4' -- csv: 4 spaces as tab

-- Folding
vim.wo.foldmethod='indent'
vim.opt.foldlevel=99

-------------------------------------------------------------------------------
--                                                                      Keymaps
--
-- See `:help vim.keymap.set()`
--
-- Set <,> as the leader key (:help mapleader)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Handle line wrapping as separate lines.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Press ESC to remove search highlight.
vim.keymap.set('n', '<ESC>', ':nohlsearch<CR>')

-- Copy and paste to system clipboard.
vim.keymap.set('', '<Leader>y', '"+y')
vim.keymap.set('', '<Leader>p', '"+p')

-- Diagnostic keymaps
vim.keymap.set('n', '[', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-------------------------------------------------------------------------------
--                                                        numToStr/Comment.nvim
--
require('Comment').setup()

-------------------------------------------------------------------------------
--                                                            folke/neodev.nvim
--
require('neodev').setup()

-------------------------------------------------------------------------------
--                                                            j-hui/fidget.nvim
--
-- require('fidget').setup()

-------------------------------------------------------------------------------
--                                                Vimjas/vim-python-pep8-indent
--
vim.g.python_pep8_indent_multiline_string = -1

-------------------------------------------------------------------------------
--                                          lukas-reineke/indent-blankline.nvim
--
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
}
vim.cmd [[highlight IndentBlanklineChar guifg=#504945 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#504945 gui=nocombine]]

-------------------------------------------------------------------------------
--                                                      lewis6991/gitsigns.nvim
--
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

-------------------------------------------------------------------------------
--                                                nvim-telescope/telescope.nvim
--
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', function()
    require('telescope.builtin').find_files{
        hidden=true,
    }
end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').builtin, { desc = '[S]earch [B]uiltins' })
vim.keymap.set('n', '<leader>sg', function()
    require('telescope.builtin').grep_string{
        shorten_path=true,
        word_match="-w",
        only_sort_text=true,
        search='',
    }
end, { desc = '[S]earch [G]rep' })

-------------------------------------------------------------------------------
--                                                             hrsh7th/nvim-cmp
--
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-------------------------------------------------------------------------------
--                                              nvim-treesitter/nvim-treesitter
--
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help' },
    highlight = { enable = true },
    indent = { enable = false },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
}

-------------------------------------------------------------------------------
--                                                        neovim/nvim-lspconfig
--
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>f', vim.lsp.buf.format, '[F]ormat current buffer with LSP')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', '[G]oto [D]efinition new tab')
    -- TODO: Create goto definition in new tab.
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

-- Enable the following language servers
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    gopls = {},
    pyright = {},
    sumneko_lua = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-------------------------------------------------------------------------------
--                                                      williamboman/mason.nvim
--
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

-------------------------------------------------------------------------------
--                                                                    nvim-lint
--
require('lint').linters_by_ft = {
    python = {'flake8',}
}
vim.cmd "autocmd BufWritePost *.py lua require('lint').try_lint()"
