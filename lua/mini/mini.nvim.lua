return { -- ============= mini.nvim ===========
  'echasnovski/mini.nvim',
  -- A collection of small independent plugins and modules
  config = function()
    --   - va)     - [V]isually select [A]round [)]paren
    --   - yinq    - [Y]ank [I]nside [N]ext [Q]uote
    --   - ci'     - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    -- Add/delete/replace surroundings (brackets, quotes, etc)
    --   - saiw)   - [S]urround [A]dd [I]nner [W]ord [)]paren
    --   - sd'     - [S]urrond [D]elete [']quote
    --   - sr)'    - [S]urround [R]eplace [)]paren with [']quote
    require('mini.surround').setup()
    -- Simple and easy statusline.
    --   You could remove this setup call if you don't like it
    --   and instead try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }
    -- You can configure sectionsin the statusline by overriding their
    --   default behavior. For examole, here we set the section for
    --   cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_locations = function()
      return '%2l:%-2v'
    end -- END 'mini.nvim.config.function().statusline.section_locations.function()
    -- For more info checkout https://github.com/echasnovski/mini.nvim
  end,  -- END 'mini.nvim'.config.function()
}       -- END PLUGIN TABLE
