return { -- ============= lazydev.nvim ===========
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- see configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
