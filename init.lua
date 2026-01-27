-- vim: ts=2 sts=2 sw=2 et
--
print 'Main config loaded > ~/.config/nvim/init.lua'

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`
require 'alpha.options'

-- [[ Set the window title to the name of the document ]]
vim.cmd 'set title'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set path for python3
-- vim.g.python3_host_prog = '/opt/homebrew/opt/python@3.12/libexec/bin/python3'

-- NOTE: Here is where you install your plugins.
require('lazy').setup(
  {

    -- Import theme first
    { import = 'themes' },

    {
      'OXY2DEV/markview.nvim',
      enabled = false,
      lazy = false,
      dependencies = {
        'saghen/blink.cmp',
      },
    },

    { import = 'core' },
    { import = 'code' },
    { import = 'debug' },
    { import = 'editor' },
    { import = 'mini' },
    { import = 'util' },
  }, -- END lazy.setup({}) where plugins are installed

  { import = 'ui' }
) -- END 'lazy'.setup({})

-- NOTE: load keymaps now that all plugins are loaded
require 'alpha.remap'
require 'alpha.autocmds'

-- NOTE: modeline setting for Neovim. Do not delete
-- The line beneath this is called `modeline`. See `:help modeline`
