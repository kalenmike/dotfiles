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
vim.keymap.set("x", "<leader>p", [["_dP]], { silent = true, desc = "Paste over selection and keep reference" })

-- Allow copy into clipboard
-- Copy what is selected
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { silent = true, desc = "Copy selection to clipboard" })
-- Copy code block or line
vim.keymap.set("n", "<leader>Y", [["+Y]], { silent = true, desc = "Copy line or block to clipoard" })

-- Start search and replace for current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Save current file path to clipboard
vim.keymap.set("n", "<leader>f", function()
    vim.fn.setreg("+", vim.fn.expand('%:p'))
end, { noremap = true, silent = true, desc = "Copy filepath to clipboard" })

-- Save File
local function saveAndNotify()
    vim.cmd('w')
    vim.notify('File saved', vim.log.levels.INFO)
end
vim.keymap.set("n", "zz", saveAndNotify, { noremap = true, silent = true, desc = "Save file" })

-- Select whole file
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select All" })

-- Go to previous file
vim.keymap.set("n", "<leader>b", ":b #<CR>", { noremap = true, silent = true })
