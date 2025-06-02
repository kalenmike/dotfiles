-- LuaLine, A blazing fast and easy to configure Neovim statusline written in Lua.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  config = function()
    vim.o.laststatus = 3
    local theme_name = vim.g.colors_name or "catppuccin"
    -- local custom_theme = require("lualine.themes.catppuccin-mocha")
    local success, custom_theme = pcall(require, "lualine.themes." .. theme_name)
    if success then
      custom_theme.normal.c.bg = "None"
    end
    require("lualine").setup({
      options = {
        theme = custom_theme, -- Or your preferred theme
        globalstatus = true,
        disabled_filetypes = { statusline = { "NvimTree" }, winbar = {} },
      },
      sections = {
        lualine_z = { "ObsessionStatus" },
      },
    })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  end,
}
