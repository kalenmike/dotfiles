return {
    'nvim-telescope/telescope.nvim',
    version = '0.1.*',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    --keys = {
    --    '<leader>pf',
    --    '<C-p>',
    --    '<leader>ps',
    --    '<leader>pb'
    --},
    config = function()
        require('telescope').setup({
            defaults = {
                initial_mode = "normal",
                mappings = {
                    n = {
                        ["q"] = require('telescope.actions').close
                    }
                },
            }
        })

        local builtin = require('telescope.builtin')
        local function project_files()
            local opts = {}
            local ok = pcall(require 'telescope.builtin'.git_files, opts)
            if not ok then require 'telescope.builtin'.find_files(opts) end
        end

        -- Fuzzy find files in git project or in cwd
        vim.keymap.set('n', '<leader>pf', project_files, { desc = "Search project files" })
        -- Fuzzy find in cwd
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        -- Fuzzy find with documents containing string
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") });
        end, { desc = "Search text in project" })
        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "View open buffers" })
    end
}
