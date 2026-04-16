return {
  "neovim/nvim-lspconfig", -- still needed for server definitions
  event = "BufReadPre",
  config = function()
    -- Signs (from lsp-zero.set_sign_icons)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
    })

    local caps = vim.lsp.protocol.make_client_capabilities()
    caps = require("cmp_nvim_lsp").default_capabilities(caps)

    vim.lsp.config("*", {
      capabilities = caps,
    })

    -- Lua
    vim.lsp.config("lua_ls", {
      capabilities = caps,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = 2, -- change to "4" if you want
            },
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME,
            },
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
    local vue_language_server_path = require("mason.settings").current.install_root_dir
      .. "/packages/vue-language-server/bin/vue-language-server"
    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    -- TypeScript / JavaScript LSP
    vim.lsp.config("ts_ls", {
      capabilities = caps,
      filetypes = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact" },
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
    })

    -- Vue (After ts_ls)
    vim.lsp.config("vue_ls", {
      filetypes = { "vue" },
      capabilities = caps,
      emmet = {
        showExpandedAbbreviation = "always",
        showAbbreviationSuggestions = true,
      },
    })

    --  Configure ESLint
    vim.lsp.config("eslint", {
      capabilities = caps,
      settings = {
        workingDirectories = { mode = "auto" },
      },
      -- on_attach = function(client, bufnr)
      --   -- Optional: Fix all errors on save
      --   vim.api.nvim_create_autocmd("BufWritePre", {
      --     buffer = bufnr,
      --     command = "EslintFixAll",
      --   })
      -- end,
    })

    -- enable servers
    vim.lsp.enable({
      "ts_ls",
      "lua_ls",
      "vue_ls",
      "eslint",
    })

    -- keymaps (replaces lsp_zero.on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })

        vim.keymap.set(
          { "n", "x" },
          "gq",
          function()
            require("conform").format({ async = true })
          end,
          vim.tbl_extend("force", opts, {
            desc = "Format document",
          })
        )

        -- set cmp sources for this buffer
        -- local cmp = require("cmp")
        -- cmp.setup.buffer({
        --   sources = {
        --     { name = "nvim_lsp" },
        --     { name = "luasnip" },
        --     { name = "buffer" },
        --     { name = "path" },
        --   },
        -- })
      end,
    })
  end,
}
