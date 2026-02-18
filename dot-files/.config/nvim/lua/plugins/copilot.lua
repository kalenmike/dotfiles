-- Official GitHub Copilot plugin for Vim/Neovim
-- return {
--     'github/copilot.vim'
-- }
-- Add copilot.lua first
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- optional: load on the Copilot command
    event = "InsertEnter", -- optional: lazy-load when entering insert mode
    config = function()
      require("copilot").setup({
        -- You can add your custom config here
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  -- Then copilot-cmp for completion integration
  {
    "zbirenbaum/copilot-cmp",
    after = "copilot.lua", -- ensure copilot.lua loads first
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
