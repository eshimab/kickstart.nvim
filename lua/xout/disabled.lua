return {

    { -- ============= mini.nvim ===========
        'echasnovski/mini.nvim',
        enabled = false,
        -- A collection of small independent plugins and modules
        config = function()
            -- Better Around/Inside  text objects
            ---
            -- Examples:
            --   - va)     - [V]isually select [A]round [)]paren
            --   - yinq    - [Y]ank [I]nside [N]ext [Q]uote
            --   - ci'     - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }
            ---
            -- Add/delete/replace surroundings (brackets, quotes, etc)
            --   - saiw)   - [S]urround [A]dd [I]nner [W]ord [)]paren
            --   - sd'     - [S]urrond [D]elete [']quote
            --   - sr)'    - [S]urround [R]eplace [)]paren with [']quote
            require('mini.surround').setup()
            ---
            -- Simple and easy statusline.
            --   You could remove this setup call if you don't like it
            --   and instead try some other statusline plugin
            local statusline = require 'mini.statusline'
            -- set use_icons to true if you have a Nerd Font
            statusline.setup { use_icons = vim.g.have_nerd_dont }
            -- You can configure sectionsin the statusline by overriding their
            --   default behavior. For examole, here we set the section for
            --   cursor location to LINE:COLUMN
            ---
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_locations = function()
                return '%2l:%-2v'
            end -- END 'mini.nvim.config.function().statusline.section_locations.function()
            -- For more info checkout https://github.com/echasnovski/mini.nvim
        end, -- END 'mini.nvim'.config.function()
    },    -- END PLUGIN TABLE

    {     -- ============= treesitter ===========
        'nvim-treesitter/nvim-treesitter',
        enabled = false,
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

    { -- ======================= nvzone/typr ====================
        'nvzone/typr',
        enabled = false,
        dependencies = 'nvzone/volt',
        linecount = 10,
        opts = {
            mode = 'words',
            linecont = 10,
            winlayout = 'responsive',
            kplayout = 'qwerty',
            wpm_goal = 130,
            numbers = true,
            symbols = true,
            random = false,
            phrases = nil, -- can be a table of strings
            insert_on_start = vim.fn.stdpath 'data' .. 'typrstats',
            mappings = nil,
            on_attach = nil,
        },
        cmd = { 'Typr', 'TyprStats' },
    },

    {
        'hrsh7th/nvim-cmp',
        enabled = false,
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & it's associated nvim-cmp source
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
                }, -- END 'LuaSnip'.dependencies
            }, -- END 'nvim-cmp'.dependencies.'LuaSnip'
            --
            'saadparwaiz1/cmp_luasnip',
            --
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
            --
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end, -- END 'nvim-cmp'.config.function().cmp.setup.snippet.expand.function(args)
                }, -- END 'nvim-cmp'.config.function().cmp.setup.snippet
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`. It is really good!
                mapping = cmp.mapping.preset.insert {
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    -- Accept ([y]es) the completion
                    --   This will auto-import if your LSP supports it.
                    --   This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },
                    -- If you prefer more traditional completion keymaps,
                    -- you can uncomment the following lines
                    -- ['<CR>'] = cmp.mapping.confirm { select = true },
                    -- ['<Tab>'] = cmp.mapping.select_next_item(),
                    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    --
                    -- Manually trigger a completion for nvim-cmp
                    --   Generally you don't need this because nvim-cmp will display
                    --   completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete {},
                    --
                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --   So if you have a snippet that's like:
                    --     function $name($args)
                    --       $body
                    --     end
                    --
                    --  <c-l> will move you to the right of each of the expansion locations
                    --  <c-h> is similar except moving you backwards
                    ['<C-l>'] = cmp.mapping(
                        function()
                            if luasnip.expand_or_locally_jumpable() then
                                luasnip.expand_or_jump()
                            end
                        end -- END 'nvim-cmp'.config.mapping.['<C-l>'].cmp.mapping.function()
                    ), -- END 'nvim-cmp'.config.mapping.['<C-l>'].cmp.mapping
                    ['<C-h>'] = cmp.mapping(
                        function()
                            if luasnip.locally_jumpable(-1) then
                                luasnip.jump(-1)
                            end
                        end -- END 'nvim-cmp'.config.mapping.['<C-h>'].cmp.mapping.function()
                    ), -- END 'nvim-cmp'.config.mapping.['<C-h>'].cmp.mapping
                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --   https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                }, -- END 'nvim-cmp'.config.function().cmp.setup.mapping.cmp.mapping.preset.insert
                --
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
            } -- END 'nvim-cmp'.config.functio().cmp.setup
        end, -- END 'nvim-cmp'.config.function()
    },     -- END 'nvim-cmp'

-- ============================= nvim-cmp ===================================
local cmp = require 'cmp'
local luasnip = require 'luasnip'
cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Select the [p]revious item
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- Accept ([y]es) the completion
    --   This will auto-import if your LSP supports it.
    --   This will expand snippets if the LSP sent a snippet.
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    -- If you prefer more traditional completion keymaps,
    -- you can uncomment the following lines
    -- ['<CR>'] = cmp.mapping.confirm { select = true },
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    --
    -- Manually trigger a completion for nvim-cmp
    --   Generally you don't need this because nvim-cmp will display
    --   completions whenever it has completion options available.
    ['<C-Space>'] = cmp.mapping.complete {},
    -- Think of <c-l> as moving to the right of your snippet expansion.
    --   So if you have a snippet that's like:
    --     function $name($args)
    --       $body
    --     end
    --  <c-l> will move you to the right of each of the expansion locations
    --  <c-h> is similar except moving you backwards
    ['<C-l>'] = cmp.mapping(
      function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end -- END 'nvim-cmp'.config.mapping.['<C-l>'].cmp.mapping.function()
    ), -- END 'nvim-cmp'.config.mapping.['<C-l>'].cmp.mapping
    ['<C-h>'] = cmp.mapping(
      function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end -- END 'nvim-cmp'.config.mapping.['<C-h>'].cmp.mapping.function()
    ), -- END 'nvim-cmp'.config.mapping.['<C-h>'].cmp.mapping
    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --   https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },
}

    {
        'neovim/nvim-lspconfig',
        enabled = false,
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependents
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            --
            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },
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
        },   -- END 'nvim-lspconfig'.dependencies
        --
        config = function()
            -- This function gets run when an LSP attaches to a particular buffer.
            --   that is to say, every time a new file is opened that is associated with
            --   an lsp (for, example, opening `main.rs` is associated with `rust_analyzer`) this
            --   function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    --  to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    --  In this case, we create a function that lets us more easilt define mappings specific
                    --    for the lsp related items. It sets the mode, buffer, and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP:' .. desc })
                    end -- END 'nvim-lspconfig'.config.function().nvim_create_autocmd.map.function(keys, func, desc)
                    --
                    -- Jump to the definition of the word under your cursor.
                    --   This is where: a variable was first declared, a function is defined, etc
                    --   To Jump back, press <C-t>
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    --
                    -- Find references for the word under your cursor
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    --
                    -- Jump to the implentation of the word uder your cursor
                    --   Useful when your language has ways of declaring types without an actual implementation
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplentation')
                    --
                    -- Jump to the type of the word under your cursor.
                    --   Useful when you're not sure what type a variable is and you want to see
                    --   the definition of it's *type*, not where it was *defined*
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    --
                    -- Fuzzy find all the symbols in your current document.
                    --   Symbols are things like variables, functions, types, etc
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    --
                    -- Fuzzy find all the symbols in your current workspace.
                    --   Similar to document symbols, except searches over your entire project
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    --
                    -- Rename the variable under your cursor
                    --   Most language servers support renaming variables across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    --
                    -- Execute a code action, usually your cursor needs to bw on top of an error
                    --   or a suggestion from your lsp for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    --
                    -- NOTE: This is NOT GoTo Definition, this is GoTo Declaration
                    --   For example, in C this would take you to the header
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    --
                    -- The following two autocommands are used to highlight references of the
                    --   word under your cursor when your cursor rests there for a little while.
                    --   See `:help CursorHold` for information about when this is executed
                    --
                    -- Whenn you move your cursor, the highlights will be cleared (the second autocommand)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
                        --
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        --
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        --
                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end -- END IF
                    --
                    -- The following code creates a keymap to toggle inlay hints in your
                    --   code, if the language server you are using supports them.
                    --
                    -- This may be unwanted because the inlay displaces some of your code
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end, -- END 'nvim-lspconfig.config.function().nvim_create_autocmd.callback.function()
            }) -- END 'nvim-lspconfig'.config.function().nvim_create_autocmd('LspAttach'...
            --
            -- LSP servers and clients are able to communicate to each other what features they supoort.
            --   By default, Neovim doesn't supoort everything that is in the LSP specification
            --   When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --   So, we create new capabilities with nvim-cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            --capabilities = vim.api.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            --
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
            }  -- END 'nvim-lspconfig'.config.function().servers
            --
            -- Ensure the servers and tools above are installed
            --   To check the current status of installed tools and/or manually install other tools,
            --   run `:Mason`
            --
            -- You can press `g?` for help in this menu.
            require('mason').setup()
            --
            -- You can add other tools here that you want Mason to install
            --   for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }
            --
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
    },     -- END PLUGIN TABLE

    {
        'lewis6991/gitsigns.nvim',
        enabled = false,
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require 'gitsigns'
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end
                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { ']c', bang = true }
                    else
                        gitsigns.nav_hunk 'next'
                    end
                end, { desc = 'Jump to next git [c]hange' })
                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk 'prev'
                    end
                end, { desc = 'Jump to previous git [c]hange' })
                -- Actions
                -- visual mode
                map('v', '<leader>hs', function()
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'stage git hunk' })
                map('v', '<leader>hr', function()
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'reset git hunk' })
                -- normal mode
                map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
                map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
                map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
                map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
                map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
                map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
                map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
                map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
                map('n', '<leader>hD', function()
                    gitsigns.diffthis '@'
                end, { desc = 'git [D]iff against last commit' })
                -- Toggles
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
                map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
            end,
        },
    },

    { -- ============= nvim-cmp (optional support for lazydev.nvim) ===========
        'hrsh7th/nvim-cmp',
        disabled = true,
        -- optional cmp completion source for require statements and module annotations
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = 'lazydev',
                group_index = 0, -- set grup index to 0 to skip loading LuaLS completions
            })
        end,
    },

    { -- ============= nvim-cmp main ===========
        'hrsh7th/nvim-cmp',
        disabled = true,
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
                },           -- END 'nvim-cmp'.config.function().cmp.setup.sources
            }                -- END 'nvim-cmp'.config.function().cmp.setup
        end,                 -- END 'nvim-cmp'.config.function()
        ----
        opts = function(_, opts) -- ========= additional configuration for lazydev.nvim
            -- optional cmp completion source for require statements and module annotations
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = 'lazydev',
                group_index = 0, -- set grup index to 0 to skip loading LuaLS completions
            })           -- end table.insert(opts.sources)
        end,             -- END opts = function(_, opts)
    },                   -- END 'nvim-cmp'

    -- ============= nvim-cmp (optional support for lazydev.nvim) ===========
    {
        'mfussenegger/nvim-dap',
        disabled = true,
        -- debug.lua
        --
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

        keys = function(_, keys)
            local dap = require 'dap'
            local dapui = require 'dapui'
            return {
                -- Basic debugging keymaps, feel free to change to your liking!
                { '<F5>',      dap.continue,          desc = 'Debug: Start/Continue' },
                { '<F1>',      dap.step_into,         desc = 'Debug: Step Into' },
                { '<F2>',      dap.step_over,         desc = 'Debug: Step Over' },
                { '<F3>',      dap.step_out,          desc = 'Debug: Step Out' },
                { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
                {
                    '<leader>B',
                    function()
                        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                    end,
                    desc = 'Debug: Set Breakpoint',
                },
                -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
                { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
                unpack(keys),
            }
        end,

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

    --[[
{                                  -- ============= guess-indent ===========
  'NMAC427/guess-indent.nvim',     -- auto indentation
  opts = {
    auto_cmd = true,               -- Enable automatic execution on buffer open
    override_editorconfig = false, -- Do not override .editorconfig settings
    filetype_exclude = {
      'netrw',                     -- Filetypes to skip auto-detection
      'tutor',
    },
    buftype_exclude = {
      'help', -- Buffer types to skip auto-detection
      'nofile',
      'terminal',
      'prompt',
    },
    on_tab_options = {
      ['expandtab'] = false, -- Vim options when tabs are detected
    },
    on_space_options = {
      ['shiftwidth'] = 'detected',  --
      ['expandtab'] = true,         -- Vim options when spaces are detected
      ['tabstop'] = 'detected',     -- Set to detected indent size
      ['softtabstop'] = 'detected', --
    },
  },
},
--]]

    --
    --
    --
} -- END OF RETURN TABLE
