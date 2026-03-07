return {
  "numToStr/Comment.nvim",
  -- Default is gcc (n) or gc (v)
  opts = {},
  config = function(_, opts)
    local ft = require("Comment.ft")

    ft.set("asm", ";%s")
  end,
}
