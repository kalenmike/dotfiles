if #vim.fn.argv() == 0 then
    vim.api.nvim_out_write("Lets get hacking!\n")
end

vim.cmd([[command! -nargs=0 MyHelp vertical edit ~/.config/nvim/shortcuts.txt]])
