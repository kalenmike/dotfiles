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
require("lazy").setup("plugins")
require("kalenmichael.set")
require("kalenmichael.remap")
-- require("kalenmichael.welcome")
require("kalenmichael.template")
require("kalenmichael.filetypes")

local function wipe_all_registers()
  local registers = {
    '"',
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
  }

  for _, reg in ipairs(registers) do
    vim.fn.setreg(reg, "")
  end
end

-- Make the function globally accessible
_G.wipe_all_registers = wipe_all_registers

vim.api.nvim_create_user_command("WipeReg", wipe_all_registers, {})
