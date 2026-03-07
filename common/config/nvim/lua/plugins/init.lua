return {
  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load First
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        auto_integrations = true,
        integrations = {
          treesitter = true, -- High-quality code highlighting
          native_lsp = {
            enabled = true, -- Colors for your code errors/warnings
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
            },
          },
          telescope = {
            enabled = true,
          },
          mason = true,
          indent_blankline = { enabled = true },
          gitsigns = true,
          notify = true,
          which_key = true,
          render_markdown = true,
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
