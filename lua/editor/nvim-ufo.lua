return { -- ============= nvim-ufo ===========
  'kevinhwang91/nvim-ufo',
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 3
    vim.o.foldenable = true
  end,
}
