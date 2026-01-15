print 'Main config loaded > ~/.config/nvim/init.lua'

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`
require 'options'

-- [[ Set the window title to the name of the document ]]
vim.cmd 'set title'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set path for python3
-- vim.g.python3_host_prog = '/opt/homebrew/opt/python@3.12/libexec/bin/python3'

-- NOTE: Here is where you install your plugins.
require('lazy').setup(
  {
    -- [[ Configure and install plugins ]]
    --  To check the current status of your plugins, run
    --    :Lazy
    --  You can press `?` in this menu for help. Use `:q` to close the window
    --  To update plugins you can run
    --    :Lazy update

    -- NOTE: Plugin: vim-sleuth
    {
      'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
      enabled = true,
    },

    { -- ============= which-key ===========
      'folke/which-key.nvim',
      event = 'VimEnter',
      config = function()
        require('which-key').add {
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        }
      end,
    },

    { -- ============= Telescope ===========
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native.nvim README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        }, -- end config for depdendency nvim-lua/plenary.nvim
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font }, -- For pretty icons etc
      }, -- END dependencies
      config = function()
        require('telescope').setup {
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          }, -- END telescope.require.setup.extensions
        } -- END telescope.require.setup
        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
      end, -- END telescope.nvim.config.function()
    },

    { -- ============= tokyonight ===========
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all other start plugins
      init = function()
        -- load colorscheme here like tokyonight-storm or tokyonight-moon, etc
        vim.cmd.colorscheme 'tokyonight'
        -- you can define highlights by using syntax like this
        vim.cmd.hi 'Comment gui=none'
      end,
    },

    { -- ============= mini.nvim ===========
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
      end, -- END 'mini.nvim'.config.function()
    }, -- END PLUGIN TABLE

    { -- ============= treesitter ===========
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
          'query',
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
      }, -- END 'nvim-treesitter'.opts
      config = function(_, opts)
        -- [[ Configure Treesitter ]] see `:help nvim-treesitter`
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
    },

    { -- ============= conform.nvim ===========
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
          } -- END 'conform.nvim'.opts.format_on_save.function(bufnr).return
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
        }, -- end formatters
      }, -- END 'conform.nvim'.opts
    }, -- END 'conform.nvim'

    { -- ============= lazydev.nvim ===========
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- see configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },

    { -- ============= blink.cmp (optional support for lazydev.nvim) ===========
      'saghen/blink.cmp',
      version = '1.8',
      build = 'cargo build --release',
      opts = {
        sources = {
          -- add lazydev to your completion providers
          default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
      },
    },

    { -- ============= nvim-cmp main ===========
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        -- Snippet Engine & it's associated nvim-cmp source
        { -- ============= LuaSnip ===========
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
          }, -- END 'LuaSnip'.dependencies
        }, -- END 'nvim-cmp'.dependencies.'LuaSnip'
        ----
        'saadparwaiz1/cmp_luasnip',
        ----
        -- Adds other completion capabilities.
        -- `nvim-cmp` does not ship with all sources by default. They are split
        -- into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      }, -- END 'nvim-cmp'.dependencies
      config = function()
        -- see `help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        ----
        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end, -- END 'nvim-cmp'.config.function().cmp.setup.snippet.expand.function(args)
          }, -- END 'nvim-cmp'.config.function().cmp.setup.snippet
          sources = {
            {
              name = 'lazydev',
              -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
              group_index = 0,
            }, -- END 'nvim-cmp'.config.function().cmp.setup.sources.'lazydev'
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
          }, -- END 'nvim-cmp'.config.function().cmp.setup.sources
        } -- END 'nvim-cmp'.config.function().cmp.setup
      end, -- END 'nvim-cmp'.config.function()
      ----
      opts = function(_, opts) -- ========= additional configuration for lazydev.nvim
        -- optional cmp completion source for require statements and module annotations
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = 'lazydev',
          group_index = 0, -- set grup index to 0 to skip loading LuaLS completions
        }) -- end table.insert(opts.sources)
      end, -- END opts = function(_, opts)
    }, -- END 'nvim-cmp'

    { -- ============= nvim-lspconfig ===========
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependents
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        --
        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },
        --
        -- `lazydev` confugres Lua LP for your neovim config, runtime and plugins used
        --   for completion, annotation, and signatures of neovim apis
        {
          'folke/lazydev.nvim',
          ft = 'lua',
          opts = {
            library = {
              -- Load luvit types when the `vim.uv` word is found
              { path = 'luvit-meta/library', words = { 'vim%.uv1' } },
            }, -- END 'nvim-lspconfig'.dependencies.'lazydev.nvim'.opts.library
          }, -- END 'nvim-lspconfig'.dependencies.'lazydev.nvim'.opts
        }, -- END 'nvim-lspconfig'.dependencies.'lazydev.nvim'
        { 'Bilal2453/luvit-meta', lazy = true },
      }, -- END 'nvim-lspconfig'.dependencies
      ----
      -- LSP servers and clients are able to communicate to each other what features they supoort.
      --   By default, Neovim doesn't supoort everything that is in the LSP specification
      --   When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --   So, we create new capabilities with nvim-cmp, and then broadcast that to the servers.
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        ----
        -- Enable the following language servers
        --   Feel free to add/remove any LSPs that you want here. They will be automatically installed.
        --
        --   Add any additional override configuration in the following tables. Available keys are:
        --     - cmd (table): Override the default command used to start the server
        --     - filetypes (table): Override the default command used to start the server
        --     - capabilities (table): Override fields in capabilities. Can be used to disable certain lsp features.
        --     - settings (table): Override the default settings passed when initializing the server.
        --         For example, to see the options for `lua_ls`, you could go to https://luals.github.io/wiki/settings/
        local servers = {
          -- clangd = {},
          -- gopls = {},
          -- pyright = {},
          -- rust_analyzer = {},
          -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
          --
          -- Some languages (like typescript) have entire language plugins that can be useful:
          --   https://github.com/pmizio/typescript-tools.nvim
          --
          -- But for many setups, the LSP (`tsserver`) will work just fine
          -- tsserver = {},
          --
          lua_ls = {
            -- cmd = { ... },
            -- filetypes = { ... },
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                --   diagnostics = {disable = 'missing-fields' } },
              }, -- END 'nvim-lspconfig'.config.function().servers.lua_ls_settings.Lua
            }, -- END 'nvim-lspconfig'.config.function().servers.lua_ls.settings
          }, -- END 'nvim-lspconfig'.config.function().servers.lua_ls
        } -- END 'nvim-lspconfig'.config.function().servers
        ----
        -- Ensure the servers and tools above are installed
        --   To check the current status of installed tools and/or manually install other tools,
        --   run `:Mason`
        --
        -- You can press `g?` for help in this menu.
        require('mason').setup()
        ----
        -- You can add other tools here that you want Mason to install
        --   for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format lua code
        })
        ----
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }
        ----
        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              --   by the server configuration above. Useful when disabling
              --   certain features of an lsp (e.g. turning off formatting for tserver)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          }, -- END 'nvim-lspconfig'.config.function().require('mason-lspconfig').setup.handlers
        } -- END 'nvim-lspconfig'.config.function().require('mason-lspconfig').setup
      end, -- END 'nvim-lspconfig'.config.function()
    },

    { -- ============= nvim-ufo ===========
      'kevinhwang91/nvim-ufo',
      config = function()
        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
      end,
    },

    { -- ============= gitsigns ===========
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '-' },
          topdelete = { text = '‾' },
          changedelte = { text = '~' },
        },
      },
    },

    { -- ============= Harpoon ===========
      'ThePrimeagen/harpoon',
      branch = 'harpoon2',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local harpoon = require 'harpoon'
        harpoon:setup()
        -- Add built-in extension for highlighting current file
        local harpoon_extensions = require 'harpoon.extensions'
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
        ----
        --[[
        -- Add telescope
        local conf = require('telescope.config').values
        ----
        local function toggle_telescope(harpoon_files)
          ----
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end
          ----
          require('telescope.pickers')
            .new({}, {
              prompt_title = 'Harpoon',
              finder = require('telescope.finders').new_table {
                results = file_paths,
              },
              previewer = conf.file_previewer {},
              sorter = conf.generic_sorter {},
              ----
            })
            :find()
          ----
        end
        vim.keymap.set('n', '<C-e>', function()
          toggle_telescope(harpoon:list())
        end, { desc = 'Open harpoon window' }) --]]
        ----
      end, -- END 'harpoon'.config.function()
    },

    { -- ============= todo-comments ===========
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      opts = {
        signs = false,
      },
    }, -- end todo-comments table

    { -- ============= autopairs ===========
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
        require('nvim-autopairs').setup {}
        local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
        local cmp = require 'cmp'
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end,
    },

    { -- ============= indent-blankline ===========
      'lukas-reineke/indent-blankline.nvim',
      -- see `:help ibl`
      main = 'ibl',
      opts = {},
    },

    { -- ============= neo-tree ===========
      'nvim-neo-tree/neo-tree.nvim',
      version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      cmd = 'Neotree',
      keys = {
        { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
      },
      opts = {
        filesystem = {
          window = {
            mappings = {
              ['\\'] = 'close_window',
            },
          },
        },
      },
    },

    { -- ============= nvim-lint ==========
      'mfussenegger/nvim-lint',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lint = require 'lint'
        lint.linters_by_ft = {
          markdown = { 'markdownlint' },
        }
        ---
        -- To allow other plugins to add linters to require('lint').linters_by_ft,
        -- instead set linters_by_ft like this:
        -- lint.linters_by_ft = lint.linters_by_ft or {}
        -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
        ---
        -- However, note that this will enable a set of default linters,
        -- which will cause errors unless these tools are available:
        -- {
        --   clojure = { "clj-kondo" },
        --   dockerfile = { "hadolint" },
        --   inko = { "inko" },
        --   janet = { "janet" },
        --   json = { "jsonlint" },
        --   markdown = { "vale" },
        --   rst = { "vale" },
        --   ruby = { "ruby" },
        --   terraform = { "tflint" },
        --   text = { "vale" }
        -- }
        --
        -- You can disable the default linters by setting their filetypes to nil:
        -- lint.linters_by_ft['clojure'] = nil
        -- lint.linters_by_ft['dockerfile'] = nil
        -- lint.linters_by_ft['inko'] = nil
        -- lint.linters_by_ft['janet'] = nil
        -- lint.linters_by_ft['json'] = nil
        -- lint.linters_by_ft['markdown'] = nil
        -- lint.linters_by_ft['rst'] = nil
        -- lint.linters_by_ft['ruby'] = nil
        -- lint.linters_by_ft['terraform'] = nil
        -- lint.linters_by_ft['text'] = nil
        ---
        -- Create autocommand which carries out the actual linting
        -- on the specified events.
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
          end,
        })
      end,
    },

    { -- ============= nvim-dap and more debugging ==========
      'mfussenegger/nvim-dap',
      disabled = false,
      -- Shows how to use the DAP plugin to debug your code.
      --
      -- Primarily focused on configuring the debugger for Go, but can
      -- be extended to other languages as well. That's why it's called
      -- kickstart.nvim and not kitchen-sink.nvim ;)
      -- NOTE: Yes, you can install new plugins here!
      -- NOTE: And you can specify dependencies as well
      dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',
        -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio',
        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
      },
      ----
      config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        ---
        require('mason-nvim-dap').setup {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,
          ---
          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},
          ---
          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
            'delve',
          },
        }
        ---
        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
          -- Set icons to characters that are more likely to work in every terminal.
          --    Feel free to remove or use ones that you like more! :)
          --    Don't feel like these are good choices.
          icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
          controls = {
            icons = {
              pause = '⏸',
              play = '▶',
              step_into = '⏎',
              step_over = '⏭',
              step_out = '⏮',
              step_back = 'b',
              run_last = '▶▶',
              terminate = '⏹',
              disconnect = '⏏',
            },
          },
        }
        ---
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
        ---
        -- Install golang specific config
        require('dap-go').setup {
          delve = {
            -- On Windows delve must be run attached or it crashes.
            -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
            detached = vim.fn.has 'win32' == 0,
          },
        }
      end,
    },

    ----
  }, -- NOTE: END lazy.setup({}) where plugins are installed

  -- NOTE: Begin Lazy ui customizations
  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      }, -- END 'lazy'.setup.ui.icons
    }, -- END 'lazy'.setup.ui
  } -- END Table 'lazy'.setup.ui
) -- NOTE: END 'lazy'.setup({})

-- NOTE: load keymaps now that all plugins are loaded
require 'remap'

-- NOTE: modeline setting for Neovim. Do not delete
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
