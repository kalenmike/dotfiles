return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.*",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  --keys = {
  --    '<leader>pf',
  --    '<C-p>',
  --    '<leader>ps',
  --    '<leader>pb'
  --},
  config = function()
    require("telescope").setup({
      defaults = {
        initial_mode = "normal",
        mappings = {
          n = {
            ["q"] = require("telescope.actions").close,
          },
        },
      },
      pickers = {
        -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
        buffers = {
          theme = "ivy",
        },
        live_grep = {
          theme = "ivy",
        },
        git_files = {
          theme = "ivy",
        },
        find_files = {
          theme = "ivy",
        },
        marks = {
          theme = "ivy",
        },
      },
      extensions = {
        fzf = {},
      },
    })

    require("telescope").load_extension("fzf")

    local builtin = require("telescope.builtin")
    local function project_files()
      local opts = {}
      -- local opts = require("telescope.themes").get_ivy(opts)
      local ok = pcall(require("telescope.builtin").git_files, opts)
      if not ok then
        require("telescope.builtin").find_files(opts)
      end
    end

    local function project_grep()
      local opts = {}

      local in_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):gsub("%s+", "") == "true"

      if in_git_repo then
        local git_cmd = "git ls-files"
        opts.search_dirs = vim.fn.split(vim.fn.system(git_cmd), "\n")
      end

      require("telescope.builtin").live_grep(opts)
    end

    -- Fuzzy find files in git project or in cwd
    vim.keymap.set("n", "<leader>pf", project_files, { desc = "Search project files" })
    -- Fuzzy find in cwd
    vim.keymap.set("n", "<C-p>", builtin.find_files, {})
    -- Fuzzy find with documents containing string
    -- vim.keymap.set("n", "<leader>ps", function()
    --   builtin.grep_string({ search = vim.fn.input("Grep > ") })
    -- end, { desc = "Search text in project" })
    vim.keymap.set("n", "<leader>ps", project_grep, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "View open buffers" })
    vim.keymap.set("n", "<leader>pr", builtin.registers, { desc = "View registers" })

    -- Show Marks
    vim.keymap.set("n", "<leader>m", "<cmd>Telescope marks<CR>", { desc = "Show marks" })
  end,
}
