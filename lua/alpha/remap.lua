-- remaps and keymaps etc

print 'Keymaps Loaded > ~/.config/nvim/lua/remap.lua'

-- Helper function to set keymaps from table
local function set_keymaps(keymap_table)
  for _, map in ipairs(keymap_table) do
    vim.keymap.set(unpack(map))
  end
end

-- ======= [[ BASIC KEYMAPS ]] =========
-- See `:help vim.keymap.set()`

-- Clear on highlight on search by pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear highlight of search' })

-- Diagnostic Keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Insert space after cursor and stay on the space in Normal Mode
require('which-key').add {
  { '<leader>s', group = '[s]pace insertions' },
  { '<leader>S', group = '[S]earch Telescope' },
}
vim.keymap.set('n', '<leader>sl', 'a <Esc>', { desc = 'Insert space after cursor' })
vim.keymap.set('n', '<leader>sh', 'i <Esc>', { desc = 'Insert space before cursor' })
vim.keymap.set('n', '<leader>sj', 'o <Esc>', { desc = 'Insert space below line' })
vim.keymap.set('n', '<leader>sk', 'O <Esc>', { desc = 'Insert space above line' })

require('which-key').add {
  { '<leader>c',  group = 'change something...' },
  { '<leader>ci', group = 'inside' },
  { '<leader>cw', group = 'inside' },
}
vim.keymap.set('n', '<leader>cx', 'ciw', { desc = '[c]hange [i]n [w]ord' })
vim.keymap.set('n', '<leader>cc', 'gcc', { desc = 'toggle comment  on line' })
vim.keymap.set('n', '<leader>cib', 'cib', { desc = '[c]hange [i]n [b]alanced pair' })
vim.keymap.set('n', '<leader>cu', 'gUiw', { desc = '[g] [U]ppercase [i]nner [w]ord' })

--vim.keymap.set('n', '<leader>csaiw', 'saiw', { desc = '[s]urround [a]dd [i]nside [w]ord' })

-- Navigation binds
local kmt_nav = {
  { 'n', '<leader>xf', vim.cmd.Ex, { desc = 'open file browser' } },
  -- Keybinds to make split navigation easier
  -- use CTRL+<hjkl> to switch between windows
}
set_keymaps(kmt_nav)

-- Code Folding
local kmt_folds = {
  { 'n', 'zh', 'zc', { desc = 'Close fold at cursor' } },
  { 'n', 'zl', 'zo', { desc = 'Open fold at cursor' } },
}
set_keymaps(kmt_folds)
-- see ':help wincmd' for a list of all window commands
local kmt_wincmd = {
  { 'n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' } },
  { 'n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' } },
  { 'n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' } },
  { 'n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' } },
}
set_keymaps(kmt_wincmd)

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ============================= conform.nvim Keymaps ===================================
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat buffer' })

--
