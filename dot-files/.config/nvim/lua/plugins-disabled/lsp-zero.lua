-- LSP Zero, Collection of functions that will help you setup Neovim's LSP client, so you can get IDE-like features with minimum effort.
-- Mason, Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- None-LS, enables non-LSP sources to integrate with Neovim's LSP client, simplifying the creation and setup of LSP sources in Lua, while reducing boilerplate and improving performance by eliminating external processes.
return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        ---Manage LSP servers from neovim
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- LSP Support
        { 'neovim/nvim-lspconfig' },

        -- Autocompletion
        { 'saghen/blink.cmp' },

        { 'nvimtools/none-ls.nvim' },
        --{ 'nvimtools/none-ls-extras.nvim' }
    },
    event = "BufReadPre",
    config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.preset('recommend')
        lsp_zero.setup()
        lsp_zero.on_attach(function(_, bufnr)
            -- see :help lsp-zero-keybindings
            -- to learn the available actions
            lsp_zero.default_keymaps({ buffer = bufnr })
            --lsp_zero.buffer_autoformat()

            vim.keymap.set({ 'n', 'x' }, 'gq', function()
                vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
            end, { buffer = bufnr, noremap = true, silent = true, desc = "Format document" })
            vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr, desc = "Find references" })
            vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<cr>', { buffer = bufnr, desc = "Show LSP Info" })
        end)

        lsp_zero.set_sign_icons({
            error = '✘',
            warn = '▲',
            hint = '⚑',
            info = '»'
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'emmet_ls' },
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    require('lspconfig').lua_ls.setup {
                        settings = {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = {
                                        'vim',
                                        'require'
                                    },
                                },
                                workspace = {
                                    -- Make the server aware of Neovim runtime files
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    }
                end
            },
        })
        local null_ls = require('null-ls')
        local null_opts = lsp_zero.build_options('null-ls', {})

        null_ls.setup({
            debug = true,
            on_attach = function(client, bufnr)
                null_opts.on_attach(client, bufnr)
            end,
            sources = {
                --null_ls.builtins.formatting.stylua,
                --require("none-ls.diagnostics.eslint_d"),
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.shfmt.with({
                    extra_args = { "-i", "4" }
                })
            }
        })

        -- Format on save
        vim.cmd([[
            augroup FormatAutogroup
                autocmd!
                autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
            augroup END
        ]])
    end
}
