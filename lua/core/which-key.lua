return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  lazy = false,
  priority = 1000,
  config = function()
    require('which-key').add {
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>w', group = '[W]orkspace' },
      { 's',         group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'zo',        hidden = true },
      { 'zc',        hidden = true },
    }
  end,
}
