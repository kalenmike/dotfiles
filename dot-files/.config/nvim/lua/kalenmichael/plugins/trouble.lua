-- Pretty inline telescope results
return {
  "folke/trouble.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = { {
    "<leader>t",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Diagnostics (Trouble)",
  } },
}
