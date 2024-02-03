-- LazyGit A simple terminal UI for git commands 
return {
    "kdheepak/lazygit.nvim",
    keys = {
        { '<leader>gs', '<cmd>LazyGit<cr>', mode = 'n', desc = 'LazyGit' }
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}
