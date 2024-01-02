return {
    -- Git change signs and blames
    { 'lewis6991/gitsigns.nvim' },
    -- Theme
    {
        'catppuccin/nvim',
        name = 'rose-pine',
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },
}
