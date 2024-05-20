
-- Vim Base Settings
vim.opt.syntax = "on"
vim.opt.filetype = "on"
vim.opt.filetype.plugin = "on"
vim.opt.filetype.indent = "on"

-- Always show status bar
vim.opt.laststatus = 2

-- Don't require backward support for vi
vim.opt.compatible = false


-- Vim Settings {{{

-- Indents and Alignment
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.showcmd = true

-- Display
vim.opt.numberwidth = 4
vim.opt.expandtab = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
-- vim.opt.cursorline!

-- Add backspace ,start <- to backspace past where you entered insert
vim.opt.backspace = { indent, eol }

vim.opt.ttyfast = true
vim.opt.autoread = true
vim.opt.more = true
vim.opt.hlsearch = true
vim.opt.smartcase = true -- " Case insensitive searches become sensitive with capitals
vim.opt.smarttab = true -- " sw at start of line, sts everywhere else

vim.opt.fileformats = { unix, dos, mac }

vim.opt.pastetoggle= '<localleader>p'

vim.opt.foldopen = vim.opt.foldopen + 'jump'
vim.opt.formatoptions = vim.opt.formatoptions + 'j'
vim.opt.dictionary = vim.opt.dictionary + '/usr/share/dict/words'

vim.cmd[[
    " Disable matchparen which jumps the cursor on matching parentheses "
    let loaded_matchparen = 1
]]

vim.cmd[[
    if exists('+breakindent')
        set breakindent showbreak=\ +
    endif
]]

vim.opt.cmdheight=2

-- NOTE: Not working in lua
-- vim.cmd[[
--     if has("eval")
--         let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
--     endif
-- ]]

vim.cmd[[
    if exists("+spelllang")
        set spelllang=en_au,en_gb
    endif
]]

-- If RG installed, use it as the vimgrep default
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

-- }}}
-- Folding {{{

vim.opt.foldmethod = "marker"
vim.opt.foldlevelstart = 0

vim.opt.foldmarker = '{{{,}}}'

-- Set space to toggle folds
vim.keymap.set({"n", "v"}, "<Space>", "za")

-- Make z0 recursively open whatever fold we're in even if it's partially open
vim.keymap.set("n", "z0", "zcz0")

-- }}}
