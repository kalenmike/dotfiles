return {
  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd("colorscheme catppuccin")

      -- Active Window
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      -- Inactive window
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      -- End of buffer
      vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#1e1e2e" })

      -- Set transparency for nvim-tree
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none", fg = "#1e1e2e" })

      -- Set background color of lualine to transparent
      vim.api.nvim_set_hl(0, "LualineNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
    end,
    opts = {
      transparent_background = true,
    },
  },
}
