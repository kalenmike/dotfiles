-- Docs: https://codecompanion.olimorris.dev/
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    interactions = {
      chat = {
        adapter = "openai",
        model = "gpt-4o-mini",
      },
    },
    display = {
      chat = {
        window = {
          position = "right",
          size = 0.4,
        },
      },
    },
    adapters = {
      http = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = "cmd: pass api/openai",
            },
          })
        end,
      },
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },
  keys = {
    {
      "<leader>cc",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Toggle CodeCompanion Chat",
      mode = "n",
    },
    {
      "<leader>ca",
      function()
        require("codecompanion").actions()
      end,
      desc = "Show CodeCompanion Actions",
      mode = "n",
    },
  },
}
