return {
  {
    "andymass/vim-matchup",
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPre",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "javascript", "typescript", "python", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = {},

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = {},

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        fold = { enable = true },
        modules = {},
        matchup = {
          enable = true, -- mandatory, false will disable the whole extension
          disable = {}, -- list of languages to disable
        },
      })
      -- Add twig formatting
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.htm",

        callback = function()
          vim.bo.filetype = "twig"
        end,
      })
      -- Add folds
      vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
        pattern = { "*.vue", "*.js", "*.ts", "*.lua" },
        callback = function(args)
          vim.opt.foldmethod = "expr"
          vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
          vim.opt.foldlevelstart = 99
          vim.opt.foldenable = false
          vim.defer_fn(function()
            vim.opt.foldmethod = vim.opt.foldmethod._value
          end, 1000)
        end,
      })
    end,
  },
}
