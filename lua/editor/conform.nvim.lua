return { -- ============= conform.nvim ===========
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    log_level = vim.log.levels.DEBUG,
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable `format_on_save lsp_fallback` for languages that don't
      -- have a well standardizec coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }  -- END 'conform.nvim'.opts.format_on_save.function(bufnr).return
    end, -- END 'conform.nvim'.opts.format_on_save.function(bufnr)
    formatters_by_ft = {
      lua = { 'stylua' },
      -- conform.nvim can also run multiple formatters sequentially e.g.:
      -- python = { 'isort', 'black'},
      -- You can use a sub-list to tell conform to run *until* a formatter is found e.g.:
      -- javascript = { { 'prettierd', 'prettier' } },
    }, -- END 'conform.nvim'.opts.formatters_by_ft
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters = {
      stylua = {
        inherit = false,
        --command = '/Users/eshim/.cargo/bin/stylua',
        command = '$HOME/.cargo/bin/stylua',
        args = {
          --'--lsp',
          --'--syntax',
          --'lua51',
          -- "--search-parent-directories",
          '--indent-width',
          '2',
          '--indent-type',
          'Spaces',
          '--stdin-filepath',
          '$FILENAME',
          '-',
        },
      }, -- end stylua
    },   -- end formatters
  },     -- END 'conform.nvim'.opts
}
