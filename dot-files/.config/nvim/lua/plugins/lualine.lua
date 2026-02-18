-- LuaLine, A blazing fast and easy to configure Neovim statusline written in Lua.
local function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return ""
    else
        return "Recording @" .. recording_register
    end
end
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = function()
        require('lualine').setup({
            sections = {
                lualine_b = { { "macro--recording", fmt = show_macro_recording } },
                lualine_z = { 'ObsessionStatus' }
            }
        })
    end
}
