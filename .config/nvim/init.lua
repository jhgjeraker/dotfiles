local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- leader must be mapped before Lazy setup (according to README)
vim.g.mapleader = ","
local languages = { "lua", "python", "go", "rust", "html", "css", "markdown" }
local servers = {
    gopls = {},
    rust_analyzer = {},
    pyright = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}
local linters = {
    python = { "flake8" },
    go = { "golangcilint" },
    sh = { "shellcheck" },
}

local plugins = {
    {
        "joshdick/onedark.vim",
        lazy = false,    -- colorschemes should not be lazy-loaded
        priority = 1000, -- make sure this plugin is loaded first
        config = function()
            vim.o.termguicolors = true
            vim.cmd([[ colorscheme onedark ]])
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        priority = 999, -- load after colorscheme
        opts = {
            options = {
                theme = "auto",
            },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime", -- lazy-load on command `StartupTime`
    },
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter", -- load cmp on InsertEnter
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- load cmp on InsertEnter
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("lurasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                },
                sources = {
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,           -- author recommends not lazy-loading mason
        config = true,          -- run setup on start
        build = ":MasonUpdate", -- run :MasonUpdate on update and/or install
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false, -- author recommends not lazy-loading mason
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason_lspconfig = require 'mason-lspconfig'
            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        settings = servers[server_name],
                    }
                end,
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        ft = languages, -- lazy-load on installed languages
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = languages,
                highlight = {
                    enable = true,
                },
            }
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        ft = languages, -- lazy-load on installed languages
        opts = {
            show_current_context = true,
        },
    },
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python", -- lazy-load on python files
    },
    {
        "windwp/nvim-autopairs",
        ft = languages, -- lazy-load on installed languages
        config = true,
    },
    {
        "mfussenegger/nvim-lint",
        ft = vim.tbl_keys(linters),
        config = function()
            require('lint').linters_by_ft = linters
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
            { "nvim-lua/plenary.nvim" },
        },
        cmd = "Telescope",
        config = function()
            local actions = require "telescope.actions"
            require("telescope").setup {
                defaults = {
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55 },
                        vertical = { mirror = false },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                        n = { q = actions.close },
                    },
                },
            }
        end,
    }
}

local opts = {
    defaults = {
        lazy = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
}

require("lazy").setup(plugins, opts)

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.ignorecase = true                         -- case insensitive search
vim.keymap.set('n', '<ESC>', ':nohlsearch<CR>') -- remove highlight by pressing Esc

vim.o.number = true                             -- line numbering
vim.o.relativenumber = true                     -- relative line numbering

-- Copy and paste to system clipboard.
vim.keymap.set('', '<Leader>y', '"+y')
vim.keymap.set('', '<Leader>p', '"+p')

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')

------------------------------------------------------------------------------
--                                                                LSP Keybinds
--
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist)
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
        end

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        nmap('gd', vim.lsp.buf.definition, "[g]oto [d]efinition")
        nmap('gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', "[g]oto [D]efinition in new tab")
        nmap('gr', vim.lsp.buf.references, "[g]oto [r]erences")
        nmap('K', vim.lsp.buf.hover, "hover")
        nmap('<leader>rn', vim.lsp.buf.rename, "rename")
        nmap('<leader>f', function() vim.lsp.buf.format { async = true } end, "format")
    end,
})
