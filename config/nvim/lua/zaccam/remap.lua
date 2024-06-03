-- All of the keymaps for neovim including some specialty functions

-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- > General Maps {{{
--------------------------------
-- remap VIM 0 to first non-blank character
map("", "0", "^")

-- Disable that goddamn 'Entering Ex mode. Type 'visual' to go to Normal mode.'
--  that I trigger 40x a day.
map("", "Q", "<Nop>")
map("", "q", "<Nop>")

-- Move to matching tags i.e. <...> via tab
map("", "<tab>", "%")

-- Delete without affecting registers
map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

------------------------------ }}}
-- > Normal Mode Map {{{
--------------------------------

-- Have capital Y yank til EOL
map("n", "Y", "y$")
-- Open Netrw Draw
map("n", "<Leader>l", ":call ToggleNetrw()<CR>")
-- Open Tagbar
map("n", "<Leader>t", ":TagbarToggle<CR>")
-- Open To Do List
map("n", "<localleader>t", ":Todo<CR>")
-- Git Status
map("n", "<leader>gs", ":G<CR>")
-- Git Blame
map("n", "<Leader>b", ":Git blame -w<CR>")

-- Keep searches centred
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

--Yank entire document to clipboard
map("n", "<leader>y", 'mzgg"+yG`z')

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

------------------------------ }}}
-- > Command Mode {{{
--------------------------------

-- Allow saving of files as sudo when I forgot to start vim using sudo.
vim.cmd("cmap w!! w !sudo tee > /dev/null %")

--------------------------------
-- }}}
-- > Insert Mode {{{
--------------------------------

-- Instead of reaching for the escape key
map("i", "kj", "<Esc>")

-- Add break points for undo
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

--------------------------------
-- }}}
-- > Visual Mode {{{
--------------------------------
map("v", "<Space>", "I<Space><Esc>gv")
--
-- Move highlighted lines up and down with auto indent formatting
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
-- Shift selected text one space and re-select
map("v", "<Space>", "I<Space><Esc>gv")

--------------------------------
-- }}}
-- > Executable Mode {{{
--------------------------------

map("x", "<leader>p", '"_dP')

--------------------------------
-- }}}

if vim.fn.has("digraphs") then
	vim.cmd("digraph ./ 8230")
end
