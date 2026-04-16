return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      sh = { "shfmt" },
      json = { "prettier" },
      ["env"] = { "shfmt" },
    },

    formatters = {
      prettier = {
        -- This forces Prettier to use the config file and defines the search path
        args = { "--stdin-filepath", "$FILENAME" },
        -- This ensures it doesn't run if no config is found (optional safety)
        require_cwd = true,
      },
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
      shfmt = {
        -- The "-p" flag makes it more compatible with POSIX shell/env files
        prepend_args = { "-i", "2", "-p" },
      },
    },
    format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = true,
    },
  },
}
