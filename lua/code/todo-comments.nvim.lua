return { -- ============= todo-comments ===========
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    signs = false,
  },
} -- end todo-comments table
