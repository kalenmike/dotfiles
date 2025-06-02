return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<leader>pv", "<cmd>NvimTreeToggle<cr>", mode = "n", desc = "Toggle Folder View" },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional
  },
  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      prefer_startup_root = true,
      sync_root_with_cwd = true,
      view = {
        width = 40,
        side = "right",
        number = true,
        relativenumber = true,
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            modified = true,
          },
          glyphs = {
            modified = "●",
          },
        },
      },
      filters = {
        dotfiles = true,
      },
      git = {
        enable = true,
        ignore = true,
        timeout = 400,
      },
    })
  end,
}
