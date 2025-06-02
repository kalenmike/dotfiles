return {
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#121212",
      timeout = 3000,
      render = "compact",
      top_down = false,
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      messages = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
      },
      notify = {
        enabled = true,
        timeout = 1,
        view = "notify",
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          enabled = false,
        },
      },
      smart_move = {
        enabled = false,
      },
    },
    views = {
      notify = {
        position = {
          row = -1,
          col = -1,
        },
        timeout = 1,
      },
      cmdline_popup = {
        position = {
          row = 5,
          col = 10,
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 23,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
          max_height = 15,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
}
