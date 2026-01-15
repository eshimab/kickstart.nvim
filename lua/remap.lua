-- remaps and keymaps etc

print 'Keymaps Loaded > ~/.config/nvim/lua/remap.lua'

-- Helper function to set keymaps from table
local function set_keymaps(keymap_table)
  for _, map in ipairs(keymap_table) do
    vim.keymap.set(unpack(map))
  end
end

-- ======= [[ BASIC KEYMAPS ]] =========
-- See `:help vim.keymap.set()`

-- Clear on highlight on search by pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Navigation binds
local kmt_nav = {
  { 'n', '<leader>xf', vim.cmd.Ex, { desc = 'open file browser' } },
  -- Keybinds to make split navigation easier
  -- use CTRL+<hjkl> to switch between windows
}
set_keymaps(kmt_nav)

-- see ':help wincmd' for a list of all window commands
local kmt_wincmd = {
  { 'n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' } },
  { 'n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' } },
  { 'n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' } },
  { 'n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' } },
}
set_keymaps(kmt_wincmd)

--
-- ============================= Harpoon Keymaps =============================
local kmt_harp = {
  -- Add file to harpoon list
  {
    'n',
    '<leader>A',
    function()
      require('harpoon'):list():add()
    end,
    { desc = 'harpoon current file' },
  },
  -- view list of harpooned files
  {
    'n',
    '<leader>a',
    function()
      require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
    end,
    { desc = 'list harpoon files' },
  },
  -- jump to harpoon files one through five
  {
    'n',
    '<leader>1',
    function()
      require('harpoon'):list():select(1)
    end,
    { desc = 'harpoon to file 1' },
  },
  {
    'n',
    '<leader>2',
    function()
      require('harpoon'):list():select(2)
    end,
    { desc = 'harpoon to file 2' },
  },
  {
    'n',
    '<leader>3',
    function()
      require('harpoon'):list():select(3)
    end,
    { desc = 'harpoon to file 3' },
  },
  {
    'n',
    '<leader>4',
    function()
      require('harpoon'):list():select(4)
    end,
    { desc = 'harpoon to file 4' },
  },
  {
    'n',
    '<leader>5',
    function()
      require('harpoon'):list():select(5)
    end,
    { desc = 'harpoon to file 5' },
  },
}
set_keymaps(kmt_harp)

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ============================= Telescope Keymaps ===================================

-- See `:help telescope.builtin`
local telebuiltin = require 'telescope.builtin'
local kmt_tele = {
  { 'n', '<leader>sh', telebuiltin.help_tags, { desc = '[S]earch [H]elp' } },
  { 'n', '<leader>sk', telebuiltin.keymaps, { desc = '[S]earch [K]eymaps' } },
  { 'n', '<leader>sf', telebuiltin.find_files, { desc = '[S]earch [F]iles' } },
  { 'n', '<leader>ss', telebuiltin.builtin, { desc = '[S]earch [S]elected Telescope' } },
  { 'n', '<leader>sw', telebuiltin.grep_string, { desc = '[S]earch current [W]ord' } },
  { 'n', '<leader>sg', telebuiltin.live_grep, { desc = '[S]earch [G]rep' } },
  { 'n', '<leader>sd', telebuiltin.diagnostics, { desc = '[S]earch [D]iagnostics' } },
  { 'n', '<leader>sr', telebuiltin.resume, { desc = '[S]earch [R]esume' } },
  { 'n', '<leader>s.', telebuiltin.oldfiles, { desc = '[S]earch Revent Files ("." for repeat)' } },
  { 'n', '<leader><leader>', telebuiltin.buffers, { desc = '[ ] Find existing buffers' } },
  -- Slightly advanced example of overriding default behavior and theme of Telescope
  {
    'n',
    '<leader>/',
    function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc
      telebuiltin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    { desc = '[/] Fuzzily search in current buffer' },
  },
  -- It's also possible to pass additional configuration options
  -- See `:help telescope.builtin.live_grep()` for information about particular keys
  {
    'n',
    '<leader>s/',
    function()
      telebuiltin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      } -- END builtin.live_grep
    end,
    { desc = '[S]earch [/] in Open Files' },
  },
  -- Shortcut for searching your Neovim configuration files
  {
    'n',
    '<leader>sn',
    function()
      telebuiltin.find_files { cwd = vim.fn.stdpath 'config' }
    end,
    { desc = '[S]earch [N]eovim files' },
  },
}
set_keymaps(kmt_tele)

-- ============================= conform.nvim Keymaps ===================================
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat buffer' })

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

-- ============================= lspconfig ===================================
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    --  to define small helper and utility functions so you don't have to repeat yourself.
    --
    --  In this case, we create a function that lets us more easilt define mappings specific
    --    for the lsp related items. It sets the mode, buffer, and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP:' .. desc })
    end -- END 'nvim-lspconfig'.config.function().nvim_create_autocmd.map.function(keys, func, desc)

    -- Jump to the definition of the word under your cursor.
    --   This is where: a variable was first declared, a function is defined, etc
    --   To Jump back, press <C-t>
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- Find references for the word under your cursor
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    -- Jump to the implentation of the word uder your cursor
    --   Useful when your language has ways of declaring types without an actual implementation
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplentation')
    -- Jump to the type of the word under your cursor.
    --   Useful when you're not sure what type a variable is and you want to see
    --   the definition of it's *type*, not where it was *defined*
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    -- Fuzzy find all the symbols in your current document.
    --   Symbols are things like variables, functions, types, etc
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    -- Fuzzy find all the symbols in your current workspace.
    --   Similar to document symbols, except searches over your entire project
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    -- Rename the variable under your cursor
    --   Most language servers support renaming variables across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    -- Execute a code action, usually your cursor needs to bw on top of an error
    --   or a suggestion from your lsp for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- NOTE: This is NOT GoTo Definition, this is GoTo Declaration
    --   For example, in C this would take you to the header
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- The following two autocommands are used to highlight references of the
    --   word under your cursor when your cursor rests there for a little while.
    --   See `:help CursorHold` for information about when this is executed

    -- Whenn you move your cursor, the highlights will be cleared (the second autocommand)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end -- END IF

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
})

-- ============================= gitsigns ===================================
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_gitsigns-attach', { clear = true }),
  callback = function()
    local gitsigns = require 'gitsigns'
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

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
})

-- ============================= nvim-dap (debugging) ===================================

local dap = require 'dap'
local dapui = require 'dapui'
local kmt_dap = {
  { 'n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' } },
  { 'n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' } },
  { 'n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' } },
  { 'n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' } },
  { 'n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' } },
  {
    'n',
    '<leader>B',
    function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end,
    { desc = 'Debug: Set Breakpoint' },
  },
  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  { 'n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' } },
}
set_keymaps(kmt_dap)

--
--
--
--
--
