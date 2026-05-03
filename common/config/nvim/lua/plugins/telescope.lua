return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.*",
  dependencies = { { "nvim-lua/plenary.nvim" } },
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
    })

    local builtin = require("telescope.builtin")

    local function project_files()
      -- Get the git root
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      local is_git = vim.v.shell_error == 0

      local opts = {
        initial_mode = "insert",
        -- Respect .gitignore by default
        hidden = false,
        -- If you want to see hidden files (like .env) but NOT .git/
        -- hidden = true,
        -- file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/", "pnpm%-lock.yaml" },
      }

      if is_git then
        opts.cwd = git_root
        builtin.find_files(opts)
      else
        builtin.find_files(opts)
      end
    end

    -- Fuzzy find files in git project or in cwd
    vim.keymap.set("n", "<leader>pf", project_files, { desc = "Search project files" })
    -- Fuzzy find in cwd
    vim.keymap.set("n", "<C-p>", builtin.find_files, {})
    -- Fuzzy find with documents containing string
    vim.keymap.set("n", "<leader>ps", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Search text in project" })
    vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "View open buffers" })

    vim.keymap.set("n", "<leader>r", function()
      require("telescope.builtin").registers()
    end, { noremap = true, silent = true, desc = "Telescope: Show registers" })
  end,
}
