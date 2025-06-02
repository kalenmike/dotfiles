-- Enables formatting and managing formatting
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- log_level = vim.log.levels.DEBUG,
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        vue = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        twig = { "djlint" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        python = { "isort", "black" },
        lua = { "stylua" },
        php = { "php_cs_fixer" },
      },
      formatters = {
        prettier = {
          prepend_args = { "--print-width", "100" }, -- Can add other options here
        },
        stylua = {
          -- Configure stylua to use spaces instead of tabs
          args = {
            "--search-parent-directories",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--stdin-filepath",
            "$FILENAME",
            "-",
          },
        },
      },
    })
  end,
}
