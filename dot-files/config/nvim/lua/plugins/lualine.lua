-- LuaLine, A blazing fast and easy to configure Neovim statusline written in Lua.
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = function()
        require('lualine').setup({
            sections = {
                lualine_z = { 'ObsessionStatus' }
            }
        })
    end
}
