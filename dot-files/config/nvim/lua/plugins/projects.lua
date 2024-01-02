return {
    'ahmedkhalf/project.nvim',
    config = function()
        require("project_nvim").setup()

        --vim.keymap.set("v", "<C-r>", vim.cmd.Telescope('projects'))
    end
}
