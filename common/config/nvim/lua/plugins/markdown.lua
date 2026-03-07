return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" },
  opts = {
    anti_conceal = { enabled = false },
    --   heading = {
    --     -- Change the signs (the # replacement)
    --     icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    --     -- Define specific colors for each header level
    --     backgrounds = {
    --       "RenderMarkdownH1Bg",
    --       "RenderMarkdownH2Bg",
    --       "RenderMarkdownH3Bg",
    --       "RenderMarkdownH4Bg",
    --       "RenderMarkdownH5Bg",
    --       "RenderMarkdownH6Bg",
    --     },
    --     foregrounds = {
    --       "RenderMarkdownH1",
    --       "RenderMarkdownH2",
    --       "RenderMarkdownH3",
    --       "RenderMarkdownH4",
    --       "RenderMarkdownH5",
    --       "RenderMarkdownH6",
    --     },
    --   },
  },
  -- config = function(_, opts)
  --   require("render-markdown").setup(opts)
  --
  --   -- Custom Highlight Groups to fix the "ugly" colors
  --   -- We use Macchiato colors: Red, Peach, Yellow, Green, Blue, Lavender
  --   local colors = {
  --     h1 = "#ed8796", -- Red
  --     h2 = "#f5a97f", -- Peach
  --     h3 = "#eed49f", -- Yellow
  --     h4 = "#a6da95", -- Green
  --     h5 = "#8aadf4", -- Blue
  --     h6 = "#b7bdf8", -- Lavender
  --   }
  --
  --   for i, color in pairs(colors) do
  --     local level = i:sub(2) -- gets the "1" from "h1"
  --     vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level, { fg = color, bold = true })
  --     -- Optional: Make the background slightly tinted (comment out if you want it clean)
  --     -- vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { fg = color, bg = "#2e3148", bold = true })
  --   end
  -- end,
}
