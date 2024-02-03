-- Conditionally install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- Lazy needs leader set before setup
vim.g.mapleader = " "
require('lazy').setup('plugins')
require("kalenmichael.set")
require("kalenmichael.remap")
--require("kalenmichael.welcome")
