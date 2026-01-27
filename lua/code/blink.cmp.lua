return { -- ============= blink.cmp ===========
  'saghen/blink.cmp',
  enabled = true,
  version = '1.*',
  build = 'cargo build --release', -- required for fuzzy.implementation.*rust*
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This step is not supported in many windows environments
        -- Remove the below condition to re-enable on windows
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end -- END if vim.fn.has
        return 'make install_jsregexp'
      end)(), -- END 'LuaSnip'.build.function()
      dependencies = {
        -- `friendly-jsnippets` contains a variety of premade snippets.
        --   See the README about individual language/framework/plugin snippets:
        --   https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafmadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end, -- END 'friendly-snippets'.config.function()
        -- }, -- END 'friendly-snippets'
      },
      opts = {},
    },
    -- another core dependency
    'folke/lazydev.nvim',
  }, -- end blink.cmp.dependencies
  -- blink.cmp optshttps://www.lazyvim.org/
  -- following two lines are for lsp only
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      -- By default, you may press `<c-space>` to show the documentation
      -- Optionally, set `auto_show = true` to show the documentation afer a delay
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 500,
      },
    },
    fuzzy = {
      -- to use a ruse based implementation, include this in blink.cmp def
      -- build = 'cargo build --release',
      implementation = 'prefer_rust_with_warning',
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = true,
      },
    },
    snippets = {
      preset = 'luasnip',
    },
    sources = {
      -- add lazydev to your completion providers
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    }, -- end blink.cmp.opts.sources
  }, -- end blink.cmp.opts
} -- end blink.cmp
