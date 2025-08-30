-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- NOTE: Section Change
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Save file using Ctrl S
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { desc = 'Save a file' })

-- File Tree
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Open File Explorer Tree', silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode. See `:help hlsearch
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- move Lines up or down
vim.keymap.set('n', 'J', ':move .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', 'K', ':move .-2<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move selected lines down', silent = true })
vim.keymap.set('v', 'K', ":move '<-2b<CR>gv=gv", { desc = 'Move selected lines up', silent = true })

-- Create split
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Split vertically', silent = true })
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = 'Split horizontally', silent = true })

-- Resize Splits
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { desc = 'Resize splits', silent = true })
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { desc = 'Resize splits', silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Resize splits', silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Resize splits', silent = true })

-- open current file in browser
-- map("n", "<leader>w", ":exe ':silent !brave %'<CR>", opts)

-- Navigate buffers
-- map("n", "<S-l>", ":bnext<CR>", opts)
-- map("n", "<S-h>", ":bprevious<CR>", opts)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Goto to Next and Previous Error
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = "Go to next diagnostic" })

-- Show Function info using hover()
vim.keymap.set('n', '<leader>ck', '<ESC>:lua vim.lsp.buf.hover()<CR>', { desc = 'Open Function Info', silent = true })

-- Invoke a Terminal
vim.keymap.set('n', '<leader>it', ':14sp +terminal<CR>i', { desc = 'Invoke Terminal', silent = true })

-- Navigate Terminal
vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Navigate Terminal' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Navigate Terminal' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Navigate Terminal' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Navigate Terminal' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode

-- Navigate Splits. See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Create new buffer in new tab
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { silent = true })

-- Go To that TAB
vim.keymap.set('n', '<c-tab>', 'gt')
vim.keymap.set('n', '<C-S-Tab>', 'gT')

-- Close that TAB
vim.keymap.set('n', '<C-w>', ':bd<CR>', { silent = true })

-- Vimwiki
-- vim.keymap.set('n', '<leader>ww', ':VimwikiIndex<CR>', { desc = 'Open Vimwiki in same tab' })
-- vim.keymap.set('n', '<leader>wt', ':VimwikiIndex<CR>', { desc = 'Open Vimwiki in another tab' })

-- Snippet jumps
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', true)
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if require('luasnip').jumpable(-1) then
    require('luasnip').jump(-1)
  end
end, { silent = true })
