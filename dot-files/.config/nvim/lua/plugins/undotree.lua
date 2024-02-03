-- Undotree visualizes the undo history and makes it easy to browse and switch between different undo branches.
return {
    'mbbill/undotree',
    init = function()
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end
}
