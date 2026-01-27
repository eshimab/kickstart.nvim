-- vim: ts=2 sw=2 sts=2 et
--
return {
  'NMAC427/guess-indent.nvim',
  -- We use 'event' to ensure the plugin is loaded when we open a file
  event = { 'BufReadPost', 'BufNewFile' },
  -- Using 'opts' automatically calls require('guess-indent').setup(opts)
  opts = {
    auto_cmd = true,               -- Automatically detect indentation on file load
    override_editorconfig = false, -- Set to true if you want to ignore .editorconfig files
    filetype_exclude = {           -- Filetypes to ignore detection
      'netrw',
      'tutor',
      'gitcommit',      -- Added gitcommit as a sensible exclusion
    },
    buftype_exclude = { -- Buffer types to ignore detection
      'help',
      'nofile',
      'terminal',
      'prompt',
    },
    on_tab_options = {
      ['expandtab'] = false,
    },
    on_space_options = {
      ['expandtab'] = true,
      ['tabstop'] = 'detected', -- 'detected' is syntactic sugar for the guessed value
      ['softtabstop'] = 'detected',
      ['shiftwidth'] = 'detected',
    },
  },
}
