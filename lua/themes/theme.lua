--
--
--
return {
  {
    'sainnhe/gruvbox-material',
    enabled = true,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'gruvbox-material'
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  { -- ============= tokyonight ===========
    'folke/tokyonight.nvim',
    enabled = false,
    priority = 1000, -- Make sure to load this before all other start plugins
    init = function()
      -- load colorscheme here like tokyonight-storm or tokyonight-moon, etc
      vim.cmd.colorscheme 'tokyonight'
      -- you can define highlights by using syntax like this
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}

