return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    messages = {
      enabled = true,
    },
    popupmenu = {
      enabled = false,
    },
    notify = {
      enabled = true,
    },
    lsp = {
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
    },
    smart_move = {
      enabled = false,
    },
    views = {
      notify = {
        replace = true,
        merge = true,
        backend = "mini",
        relative = "editor",
        position = {
          row = 2,
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
          max_width = 40,
        },
        border = {
          style = "rounded",
        },
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
}
