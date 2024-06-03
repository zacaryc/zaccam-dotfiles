
-- Make the settings below more succinct
local opt = vim.opt

-- Vim Base Settings {{{
opt.syntax = "on"
opt.filetype = "on"
opt.filetype.plugin = "on"
opt.filetype.indent = "on"

-- Always show status bar
opt.laststatus = 2

-- Don't require backward support for vi
opt.compatible = false

-- }}}

-- Indents and Alignment {{{
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.textwidth = 80
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.formatoptions = opt.formatoptions + 'j'

-- }}}

-- Display {{{
opt.ruler = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.scrolloff = 8
opt.showcmd = true
opt.cmdheight=2
-- opt.cursorline!
-- Keep sign column on by default
-- opt.signcolumn = "on"

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Show which line cursor is on
opt.cursorline = true

-- Breaks
opt.breakindent = true
opt.showbreak = ' +'

-- }}}

-- Functionality {{{

-- Add backspace ,start <- to backspace past where you entered insert
opt.backspace = { indent, eol }

-- Set Highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Preview Substitutions live, as you type
opt.inccommand = "split"

opt.smartcase = true -- " Case insensitive searches become sensitive with capitals
opt.smarttab = true -- " sw at start of line, sts everywhere else
opt.ttyfast = true
opt.autoread = true
opt.more = true
opt.mouse = "a"

-- Sync clipboard between OS and Neovim
opt.clipboard = "unnamedplus"

-- Save undo history
opt.undofile = true

-- Decrease Update Time
opt.updatetime = 250

opt.fileformats = { unix, dos, mac }

vim.keymap.set("n", "<localleader>p", ":set paste!<CR>")

opt.dictionary = opt.dictionary + '/usr/share/dict/words'
opt.spelllang = { en_au, en_gb }

-- Disable matchparen which jumps the cursor on matching parentheses "
vim.cmd('let loaded_matchparen = 1')

-- If RG installed, use it as the vimgrep default
if vim.fn.executable('rg') == 1 then
  opt.grepprg = 'rg --vimgrep'
  opt.grepformat = '%f:%l:%c:%m'
end

-- }}}

-- Folding {{{

opt.foldopen = opt.foldopen + 'jump'
opt.foldmethod = "marker"
opt.foldlevelstart = 0
opt.foldmarker = '{{{,}}}'

-- Set space to toggle folds
vim.keymap.set({"n", "v"}, "<Space>", "za")

-- Make z0 recursively open whatever fold we're in even if it's partially open
vim.keymap.set("n", "z0", "zcz0")

-- }}}
