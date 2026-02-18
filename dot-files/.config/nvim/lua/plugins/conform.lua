return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      vue = { "prettier" },
      sh = { "shfmt" },
    },

    formatters = {
      stylua = {
        args = {
          "-", -- read from stdin
          "--stdin-filepath",
          "%filepath%", -- tell stylua the filename
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
        },
      },
    },
    format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = true,
    },
  },
}
