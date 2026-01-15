print 'Options Loaded > ~/.config/nvim/lua/options.lua'

-- ======= [[ SETTING OPTIONS ]] ============
-- see `:help vim.opt`
-- For more options you can see `:help option-list`
-- Edit options using `:options`

-- ======= [[ SANE DEFAULTS ]] ========
-- These are options with their default values
vim.opt.autoindent = true
vim.opt.shiftwidth = 4 -- We ensure this workd in the /after dir

vim.opt.autoread = true
vim.opt.autowrite = false
vim.opt.autowriteall = false
vim.opt.background = 'dark'

vim.opt.backspace = 'indent,eol,start'
-- 'backspace' 'bs'    string (default "indent,eol,start")
--     Influence the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert Mode
--     Keyword >> Effect
--     indent  >> allow backspacing over autoindent
--     eol     >> allow backspacing over line breaks (i.e. join lines)
--     start   >> allow backspacing over start of insert; CTRL-W and CTRL-U stop once at the start of insert.
--     nostop  >> like start, except CTRL-W and CTRL-U do not stop at the start of the line

vim.opt.backup = false
-- 'backup' 'bk' 'nobackup' 'nbk'
--     This is superceded by the default option 'writebackup`

vim.opt.backupext = 'bakext'
-- 'backupext' 'bex'
--     String which is appended to a file name to make the name of the backup file.

vim.opt.belloff = 'all'
-- 'belloff' 'bo'
--     Specifies for which eventd the bell will not be rung.

vim.opt.binary = false
-- 'binary' 'bin' 'nobinary' 'nobin'
--     This option should be set before editing a binary file.
--     You can also use the -b Vim argument.
--

-- highlight searched for text
vim.opt.hlsearch = true

vim.opt.writebackup = true
-- 'writebackup' 'wb' 'nowritebackup' 'nowb'
--     Make a backup file before overwriting a file.
--     The backu0p is remobed after the file was successfully overwritten, unless the 'backup' option is also on
-- ======= FOLDING =======
vim.opt.foldmethod = 'indent'

-- ======= UNDOS ======
vim.opt.undolevels = 2000
vim.opt.undofile = true
-- ========= UI ==============
-- Show editing mode?
vim.opt.showmode = true

vim.opt.breakindent = true

-- save undo history
vim.opt.undofile = true

--Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default?
vim.opt.signcolumn = 'yes'

-- Decrease update time?
vim.opt.updatetime = 250

-- Configure how new splits should be opened?
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set how neovim will display certain whitespace characters in the editor?
-- Show <Tab> and <EOL> ?
vim.opt.list = true
-- Characters for displaying in list mode?
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live as you type?
vim.opt.inccommand = 'split'

-- Show which line your cursor is on?
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- ========== LINE NUMBERS =====================
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = false

-- ============= MOUSE MODE ========================
-- Enable mouse, may be useful for resizing split windows
vim.opt.mouse = 'a'

-- ============ CLIPBOARD ====================
-- Sync clipboard between OS and NEOVIM
-- Remove this option if you want your OS clipboard to remain independent
-- see `:help clipboard`
-- vim.opt.clipboard = 'unnamedplus'
-- Leave the clipboard option blank (the default) to give direct access to registers
vim.opt.clipboard = ''
