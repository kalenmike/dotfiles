-- ============================================================
-- Neovim Options Configuration
-- ============================================================
--
-- Sections:
-- 1. Line Numbers
-- 2. Tabs and Indentation
-- 3. Wrapping
-- 4. File Handling
-- 5. Search
-- 6. Appearance / Colors
-- 7. Performance
-- 8. Whitespace / Invisible Characters
-- 9. UI / Behavior
-- 10. Spell Checking
-- 11. Leader Key
-- 12. Disable Built-in Plugins
-- 13. Messaging
--
-- Each section contains options with comments explaining their purpose.
-- ============================================================

-- =====================
-- Line Numbers
-- =====================
vim.opt.nu = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- =====================
-- Tabs and Indentation
-- =====================
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces for editing operations (insert/delete)
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Enable basic smart indentation

-- =====================
-- Wrapping
-- =====================
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Wrap at word boundaries
vim.opt.showbreak = "↳ " -- Symbol at the start of wrapped lines
vim.opt.breakindent = true -- Indent wrapped lines to match start of text
vim.opt.breakindentopt = "shift:0,min:20" -- Optional fine-tuning for breakindent

-- =====================
-- File Handling
-- =====================
vim.opt.swapfile = false -- Disable swap files
vim.opt.backup = false -- Disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undodir" -- Undo directory
vim.opt.undofile = true -- Enable persistent undo

-- =====================
-- Search
-- =====================
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if query has uppercase

-- =====================
-- Appearance / Colors
-- =====================
vim.opt.termguicolors = true -- Enable true color support
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
vim.opt.isfname:append("@-@") -- Include '@' in file names
-- vim.opt.colorcolumn = "80" -- Eg: This is some text… | ← column 80 is marked here
--vim.opt.signcolumn = "no" -- hides the sign column completely

-- =====================
-- Performance
-- =====================
vim.opt.updatetime = 50 -- Faster update time for CursorHold and other events

-- =====================
-- Whitespace / Invisible Characters
-- =====================
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { -- Customize how invisible characters are displayed
  tab = "→ ",
  space = "·",
  trail = "·",
  extends = ">",
  precedes = "<",
  nbsp = "␣",
}

-- =====================
-- UI / Behavior
-- =====================
vim.opt.showmode = false -- Disable mode display (e.g., -- INSERT --)
-- vim.opt.autochdir = true          -- Uncomment to automatically change working directory
vim.opt.cmdheight = 0 -- Minimal command line height
vim.opt.mouse = "a" -- Enable mouse for all modes
vim.opt.clipboard = "unnamedplus"

-- Auto read the file for monitoring changes
vim.opt.autoread = true

-- =====================
-- Spell Checking
-- =====================
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es" }

-- =====================
-- Leader Key
-- =====================
vim.g.mapleader = " " -- Set leader key to space

-- =====================
-- Disable Built-in Plugins
-- =====================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- =====================
-- Messaging
-- =====================
vim.opt.shortmess:append("I") -- Remove intro messages

vim.g.copilot_enabled = false
