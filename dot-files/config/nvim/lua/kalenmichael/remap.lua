-- Map netrw if enabled
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) --In normal mode execute command with keystroke

-- Move selection with indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in one place when page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in same place when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Allow paste over new selection without losing reference
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Allow copy into clipboard
-- Copy what is selected
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Copy code block or line
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Start search and replace for current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
