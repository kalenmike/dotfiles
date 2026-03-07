-- ============================================================
-- Neovim Keymaps
-- ============================================================
--
-- Layout of each keymap:
-- Mode      : n = normal, v = visual, x = visual/select, i = insert, t = terminal
-- Shortcut  : Key combination to trigger the command
-- Command   : Action performed (Vim command or Lua function)
-- Options   : Additional behavior (noremap, silent, desc, expr, etc.)
--
-- Sections:
-- 1. Netrw / File Explorer
-- 2. Visual Mode Movement
-- 3. Cursor Positioning
-- 4. Clipboard / Pasting
-- 5. Search & Replace
-- 6. File Operations
-- 7. Window / Buffer Management
-- 8. Quickfix Navigation
-- ============================================================

-- =====================
-- Netrw / File Explorer
-- =====================
-- Map netrw if enabled
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) --In normal mode execute command with keystroke

-- =====================
-- Visual Mode Movement
-- =====================
-- Move selected lines up/down while keeping selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in Visual Block mode after indent
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- =====================
-- Cursor Positioning
-- =====================
-- Keep cursor centered when scrolling half-page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half-page up and center" })

-- Keep cursor centered when navigating search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Swap go to line start and go to start after indent
vim.keymap.set({ "n", "v" }, "0", "^", { desc = "Go to first non-blank character" })
vim.keymap.set({ "n", "v" }, "^", "0", { desc = "Go to absolute line start" })

-- =====================
-- Clipboard / Pasting
-- =====================
-- Paste over selection without overwriting clipboard
vim.keymap.set("x", "<leader>p", [["_dP]], { silent = true, desc = "Paste over selection and keep reference" })

vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "Delete character without yanking" })

-- Copy to system clipboard (When not using vim.opt.keyboard = 'unnamedplus')
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { silent = true, desc = "Copy selection to clipboard" })
-- Copy code block or line
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { silent = true, desc = "Copy line or block to clipoard" })

-- =====================
-- Search & Replace
-- =====================
-- Start search/replace for current word under cursor
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word" }
)

-- =====================
-- File Operations
-- =====================
-- Make file executable
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Copy full file path to clipboard
vim.keymap.set("n", "<leader>f", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { noremap = true, silent = true, desc = "Copy filepath to clipboard" })

-- Save file with notification
local function saveAndNotify()
  vim.cmd("w")
  vim.notify("File saved", vim.log.levels.INFO)
end
vim.keymap.set("n", "zz", saveAndNotify, { noremap = true, silent = true, desc = "Save file" })

-- Select entire file
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select All" })

-- =====================
-- Window / Buffer Management
-- =====================
-- Go to previous file
vim.keymap.set("n", "<leader>b", ":b #<CR>", { noremap = true, silent = true, desc = "Switch to previous buffer" })

-- Close Windows
vim.keymap.set("n", "<leader>q", ":q<Return>", { noremap = true, silent = true, desc = "Close Window" })
vim.keymap.set("n", "<leader>Q", ":qa<Return>", { noremap = true, silent = true, desc = "Close All Windows" })

-- Toggle wrap in the current window
local function toggle_wrap()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end

vim.keymap.set("n", "<leader>w", toggle_wrap, { noremap = true, silent = true, desc = "Toggle line wrap" })

-- =====================
-- Quickfix Navigation
-- =====================
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
