return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        formatting = {
          format = function(entry, vim_item)
            local client_name = entry.source.source.client.name

            if client_name == "marksman" then
              vim_item.word = vim_item.abbr
            end

            return vim_item
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = {
          { name = "copilot" },
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              -- Only apply this logic in markdown files
              if vim.bo.filetype ~= "markdown" then
                return true
              end

              local item = entry:get_completion_item()
              -- We only want to target WikiLinks (which Marksman handles)
              -- Marksman uses the 'label' for the correctly cased filename
              if item.label and item.textEdit then
                item.textEdit.newText = item.label
              end

              return true
            end,
          },
          { name = "buffer" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
}
