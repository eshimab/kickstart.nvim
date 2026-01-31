return { -- ============= treesitter ===========
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'sql',
      'vim',
      'vimdoc',
    }, -- END 'nvim-treesitter'.opts.ensure_installed
    -- Auto install languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlightuing system (such as Ruby) for indent rules.
      --   If you are experiencing weird indenting issues, add the language to
      --   the list of additional_vim_regex_highlighting and disable languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    }, -- END 'nvim-treesitter'.opts.highlight
    indent = { enable = true, disable = { 'ruby' } },
  },   -- END 'nvim-treesitter'.opts
  config = function(_, opts)
    --  Configure Treesitter  see `:help nvim-treesitter`
    --
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
    --
    -- There are additional nvim-treesitter modules that you can use to interact
    --   with nvim-treesitter.
    --   -  Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --   -  Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --   -  Treesitter + Text Objects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end, -- END 'nvim-treesitter-.config.function(_, opts)
}
