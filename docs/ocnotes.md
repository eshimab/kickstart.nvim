# nvim config updates

### Summary of Major Changes in Kickstart (Compared to Your Config)
Kickstart has evolved significantly since many users forked it. It now prioritizes modern, lightweight plugins and has streamlined its LSP/completion setup. Your config includes many additional plugins (e.g., Harpoon, Neo-tree, DAP), which are customizations beyond the base kickstart.ের core differences are in completion (switched to Blink), LSP tooling (Mason updates), and indentation detection.

### Plugin Differences
Here's a side-by-side of the default plugins in kickstart vs. your config. I've noted additions, removals, and replacements.

| **Plugin/Category**  | **Kickstart (Current)**                                        | **Your Config**                                                               | **Notes/Recommendation**                                          |
|----------------------|----------------------------------------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------------------------|
| **Indent Detection** | `NMAC427/guess-indent.nvim` (new)                              | `tpope/vim-sleuth`                                                            | **[1]**                                                           |
| **Completion**       | `saghen/blink.cmp` (primary, with LuaSnip)                     | `hrsh7th/nvim-cmp` (old) + `saghen/blink.cmp` (you have both!)                | **[2]**                                                           |
| **LSP Tooling**      | `mason-org/mason.nvim` (new org) + `mason-org/mason-lspconfig` | `williamboman/mason.nvim` + `williamboman/mason-lspconfig`                    | **[3]**                                                           |
| **Snippet Engine**   | LuaSnip (built into Blink)                                     | LuaSnip + nvim-cmp setup                                                      | No major change, but integrated tighter with Blink in kickstart.  |
| **Formatting**       | `stevearc/conform.nvim`                                        | `stevearc/conform.nvim`                                                       | Same plugin, but config differs (see below).                      |
| **Statusline**       | Mini.statusline                                                | Mini.statusline                                                               | Same.                                                             |
| **Treesitter**       | `nvim-treesitter`                                              | `nvim-treesitter`                                                             | Same, but kickstart added `diff` to ensure_installed.             |

#### Plugin Differences Notes

1. Kickstart replaced vim-sleuth with guess-indent for better auto-detection. If you're happy with vim-sleuth, no need to change; guess-indent is more modern but similar.
2. Kickstart fully switched to Blink.cmp as the default (faster, simpler than nvim-cmp). You have both installed—consider removing nvim-cmp to avoid conflicts and match kickstart. Blink is now the recommended choice.
3. Kickstart updated to the new `mason-org` namespace (the original maintainer moved). Your config uses the old `williamboman`—update to avoid deprecation warnings.

### Plugins You Have That Kickstart Removed as Defaults
- Harpoon, Neo-tree, nvim-ufo, nvim-autopairs, indent-blankline, nvim-lint, nvim-dap: These were in older kickstart versions but stripped out for simplicity. Kickstart now focuses on core LSP/completion without extras.

### Configuration Differences
- **LSP Keymaps**: Kickstart updated to more mnemonic keys (e.g., `grn` for rename, `gra` for code action) instead of your `gd`, `gr`, etc. It's more consistent with LSP conventions.
- **Conform (Formatting)**: Your config uses `lsp_fallback = not disable_filetypes[ft]`, while kickstart uses `lsp_format = 'fallback'` and `lsp_format = 'fallback'` in format_on_save. Kickstart's is simpler and more reliable.
- **Blink.cmp**: Kickstart has detailed opts for keymap presets, appearance, and fuzzy matching. Your config has Blink but less config—kickstart's is more polished.
- **Mason**: Kickstart sets `automatic_installation = false` and ensures tools via mason-tool-installer. Your config is similar but uses the old namespace.
- **Options**: Kickstart added `confirm = true` for unsaved buffers, and `scrolloff = 10`. You have similar but not these exact tweaks.
- **Autocommands**: Kickstart improved LSP attach/detach with better client method checks for Neovim 0.11 compatibility.

### Recommendations
1. **Update to Match Kickstart for Stability**: Switch to `mason-org/mason*`, replace `williamboman` versions. Remove `nvim-cmp` and rely solely on Blink (it's better). Update conform opts to kickstart's for consistency.
2. **Keep Your Extras**: Plugins like Harpoon and Neo-tree aren't in kickstart anymore, but they're useful—retain them.
3. **Test Before Merging**: Kickstart's LSP keymaps are better; consider adopting them to align.
4. **No Urgent Changes**: If your config works, you don't *need* to update. But for future-proofing (e.g., Blink is faster), it's worth it.
5. **Potential Issues**: Having both nvim-cmp and Blink could cause conflicts—remove nvim-cmp.

If you'd like me to prepare a plan to update your config (e.g., edit init.lua to match kickstart's changes while preserving your additions), or focus on specific plugins, let me know!

## Lazy.nvim Installation Example for guess-indent

To install `guess-indent.nvim` using lazy.nvim with all available properties specified (many are optional and set to defaults), here's a complete plugin spec you can add to your `lazy.setup({})` plugins table. This assumes you're using lazy.nvim's standard syntax; adjust as needed for your config.

```lua
{
  'NMAC427/guess-indent.nvim',  -- Plugin name/URL
  name = 'guess-indent',  -- Optional: custom name (defaults to repo name)
  url = nil,  -- Optional: override URL if needed (defaults to GitHub)
  dir = nil,  -- Optional: local directory path (defaults to lazy's data dir)
  dev = false,  -- Optional: treat as dev plugin (false)
  lazy = false,  -- Optional: load lazily (false means load on startup)
  enabled = true,  -- Optional: enable/disable plugin (true)
  cond = nil,  -- Optional: condition function to load (nil means always)
  dependencies = {},  -- Optional: list of dependencies (none for this plugin)
  init = nil,  -- Optional: function to run before loading (nil)
  opts = {},  -- Optional: options passed to setup (can be table or function)
  config = function(_, opts)  -- Optional: config function (runs after loading)
    require('guess-indent').setup(opts or {})
  end,
  build = nil,  -- Optional: build command (none needed)
  branch = nil,  -- Optional: git branch (defaults to 'main')
  tag = nil,  -- Optional: git tag (nil)
  commit = nil,  -- Optional: git commit hash (nil)
  version = nil,  -- Optional: version constraint (nil)
  pin = false,  -- Optional: pin to current version (false)
  event = nil,  -- Optional: load on event (nil for auto)
  cmd = nil,  -- Optional: load on command (nil)
  ft = nil,  -- Optional: load on filetype (nil)
  keys = nil,  -- Optional: load on keymap (nil)
  priority = 50,  -- Optional: load priority (50 default)
  optional = false,  -- Optional: mark as optional dependency (false)
  rocks = nil,  -- Optional: luarocks spec (nil)
  main = nil,  -- Optional: main module for opts merging (nil)
}
```

This is a full spec with all lazy.nvim properties listed (based on lazy.nvim docs). For guess-indent, only `config` or `opts` are typically needed—the rest can be omitted for simplicity. If you use `opts`, pass your config table directly (e.g., `opts = { auto_cmd = true }`). Test in a non-critical buffer first. If you want to integrate this into your existing config, let me know specifics.

## EmmyLua Annotations

```

    { -- ============= blink.cmp (optional support for lazydev.nvim) ===========
      'saghen/blink.cmp',
      version = '1.*',
      build = 'cargo build --release',
      dependencies = {},
      -- blink.cmp opts
      -- following two lines are for lsp only And they are called "EmmyLua annotations"
      --- @module 'blink.cmp'
      --- @type blink.cmp.Config
      opts = {},
```
1. The term for these LSP helpers like `--- @module 'blink.cmp'` is **EmmyLua annotations** (or EmmyLua type annotations/doc comments).
2. They are special comment syntax in Lua that provides type information and documentation hints to LSPs like lua_ls, enabling better IntelliSense, error checking, and autocompletion in your editor.
3. They're part of the EmmyLua specification for Lua tooling.
4. If you want to add more (e.g., for functions), check lua_ls docs for syntax.
5. Do not add comments to the ends of these lines.

## Plan to Resolve the Persistent Telescope Config Error

Based on reading your `remap.lua` file, the structure for exporting `M.telescope_keymaps` looks correct (M = {} at top, assignment on line 160, set_keymaps on line 162, return M at line 338). You confirmed `set_keymaps(M.telescope_keymaps)` works, so the table itself is fine. However, the Telescope config still fails on `require 'remap'` with an error at `remap.lua:112`. This suggests a parsing/compilation issue in `remap.lua` that only surfaces on require (not on direct execution). Here's a diagnostic plan to isolate and fix it.

1. **Confirm Current State**
   - The require succeeds manually, so `remap.lua` is syntactically valid and exports `M` correctly.
   - Your test of `set_keymaps(M.telescope_keymaps)` working means the table is properly formed.
   - The error persists in Telescope config, pointing to how `init.lua` handles the require or processes the table.

2. **Likely Causes**
   1. **Cached Error**: Neovim may be using a cached failed require. The "previous error" could be from an earlier broken version.
   2. **Config Function Issue**: The loop in Telescope's `config` (e.g., `for _, km in ipairs(remap.telescope_keymaps) do vim.keymap.set(unpack(km)) end`) might fail if an entry in `telescope_keymaps` has incorrect args (e.g., wrong number of unpack values).
   3. **Timing/Dependency**: Telescope loads early; if `remap.lua` depends on something not ready yet, it could fail.
   4. **Unpack Error**: `unpack(km)` expects exactly 4 values (`mode`, `lhs`, `rhs`, `opts`), but if an entry is malformed (e.g., missing `opts`), it errors.

3. **Diagnostic Steps** (You Can Perform)
   1. **Clear Caches and Reload**:
      - Run `:lua package.loaded.remap = nil; package.loaded['telescope'] = nil` to reset caches.
      - Fully quit Neovim (not just `:qa`), then reopen to force fresh loads.
   2. **Test Table Contents**: Run `:lua local r = require 'remap'; for i, km in ipairs(r.telescope_keymaps) do print(i, vim.inspect(km)) end` to inspect each entry. Ensure each is a table with 4 elements.
   3. **Isolate Telescope Config**: Temporarily comment out the remap-related lines in Telescope's `config` function (around line 110 in `init.lua`), reload, and check if Telescope loads. If yes, the issue is in the loop.
   4. **Check Unpack Manually**: Run `:lua local r = require 'remap'; vim.keymap.set(unpack(r.telescope_keymaps[1]))` to test the first entry. If it fails, fix that entry.
   5. **Error Details**: After reload, check `:messages` again for updated errors. Note if the line number changed.
   6. **Post-Fix Verification**: Reload and test `:Telescope help_tags` and `<leader>sh`. If fixed, the import works; if not, share the new error details.

### Getting a List of Neovim Keymaps

#### Using Built-in Neovim Commands (Simple and Immediate)
1. **Basic List**: Run `:map` in Neovim to see all keymaps across modes (normal, visual, insert, etc.). It shows the key sequence, mapped action, and mode.
2. **Filtered by Mode**: Use `:nmap` (normal), `:vmap` (visual), `:imap` (insert), `:cmap` (command-line), etc., for specific modes. E.g., `:nmap` for leader keymaps like `<leader>s`.
3. **Verbose Details**: Add `verbose` for source info: `:verbose map <leader>` shows where each map is defined (e.g., your remap.lua or plugin files).
4. **Pros**: Instant, no plugins needed; shows current state.
5. **Cons**: Can be overwhelming (hundreds of lines); no search/filter beyond mode.

#### Using Telescope (If Available in Your Config)
1. **Command**: `:Telescope keymaps` opens a searchable list of all keymaps. You can type to filter (e.g., by `<leader>` or "search").
2. **How It Works**: Leverages your Telescope setup (from `lua/core/telescope.lua`). It pulls from Neovim's internal map list.
3. **Preview**: Select a map to see its action and source.
4. **Pros**: Interactive search; integrates with your config; easy to browse.
5. **Cons**: Requires Telescope loaded; might not show plugin-specific maps until plugins are loaded.

#### Using Which-Key (If Available)
1. **Command**: If `folke/which-key` is enabled (from your tokyonight config), press `<leader>` and wait for the popup showing available keymaps starting with leader.
2. **Full List**: `:WhichKey` or similar commands (check `:help which-key` for exact syntax).
3. **Pros**: Visual, grouped by prefix (e.g., `<leader>s` for search); shows descriptions from your `desc` fields.
4. **Cons**: Only shows configured maps; requires the plugin.

#### Exporting or Scripting for Full Lists
1. **To File**: Run `:redir > /tmp/keymaps.txt | silent map | redir END` to save all maps to a file, then view/edit it.
2. **Filtered**: Replace `map` with `nmap` for normal mode only.
3. **Pros**: For backup or analysis; can be scripted for automation.
4. **Cons**: Manual; requires file access.

#### Troubleshooting and Tips
1. **Loading Issue**: If maps aren't showing, ensure plugins are loaded (e.g., `:Lazy sync` for your imports). Check `:messages` for errors.
2. **Custom Maps**: Your leader maps (e.g., `<leader>s`) are in `lua/core/telescope.lua` now— they should appear after the file loads.
3. **Conflicts**: If maps are overridden, `:verbose map <key>` shows the last definition.
4. **Performance**: For large lists, pipe to `less` or grep: `:map | grep leader`.

#### Recommended Starting Point
1. Try `:Telescope keymaps` first for an interactive list (fits your config).
2. If you want a specific subset (e.g., only leader keys or a certain mode), clarify for a tailored command.

### Find and Replace in Neovim

#### Case-Sensitive Separate Commands
Replace both variations with individual commands:

```vim
:%s/v_eq_n2/v02_n2/g
```

#### Case-Insensitive Single Command
Use case-insensitive flag to catch both patterns at once:

```vim
:%s/\cv_eq_n2/v02_n2/g
```

#### Pattern Alternation
Match both exact patterns with alternation:

```vim
:%s/\v(v_eq_n2|V_EQ_N2)/v02_n2/g
```

#### Very Magic with Case-Insensitive Flag
Combine very magic mode with case-insensitivity:

```vim
:%s/\vv_eq_n2/v02_n2/gi
```

**Recommendation**: Use `:%s/\cv_eq_n2/v02_n2/g` for clean, efficient replacement of both variations.

### Neovim Substitute Command Syntax Breakdown

#### Command Components
In `:%s/v_eq_n2/v02_n2/g`, each part has specific meaning:

##### Range Specifier (`%`)
- `%` - Entire file (all lines)
- `:s` - Current line only  
- `:1,5s` - Lines 1-5
- `:'<,'>s` - Visually selected lines

##### Substitute Command (`s`)
- `s` - Core search and replace operation

##### Patterns
- `v_eq_n2` - Search pattern (what to find)
- `v02_n2` - Replacement pattern (what to replace with)

##### Flags (`g`)
- `g` - Global flag. Without it: only first occurrence per line replaced. With it: ALL occurrences per line replaced.

#### Other Common Flags
```vim
i  - case-insensitive
c  - confirm each replacement  
I  - case-sensitive (when 'ignorecase' is set)
```

#### Full Command Meaning
"Across the entire file (`%`), substitute (`s`) all occurrences of `v_eq_n2` with `v02_n2`, globally on each line (`g`)."

### Very Magic Mode (\v) in Neovim Search

#### What is Very Magic (`\v`)?
The `\v` flag enables "very magic" mode which changes regex character interpretation:

- `\v` = Very magic mode
- Most regex metacharacters don't need escaping
- Makes regex patterns cleaner and more readable

#### Regex Behavior Comparison

**Without `\v` (default magic):**
```vim
:%s/(foo|bar)/baz/g     # Won't work - need escaping
:%s/\(foo\|bar\)/baz/g  # Correct but verbose
```

**With `\v` (very magic):**
```vim
:%s/\v(foo|bar)/baz/g   # Works directly - cleaner
```

#### Why Used in Your Example
In `:%s/\vv_eq_n2/v02_n2/gi`, the `\v` isn't strictly necessary since `v_eq_n2` has no special regex characters, but it's good practice when:

- Pattern contains regex metacharacters like `()`, `|`, `+`, `?`, `{}`
- Want consistent "very magic" behavior across searches
- Coming from other regex engines where this syntax is common

#### Magic Levels Available
```vim
\v  # Very magic: most characters are special
\m  # Magic (default): fewer characters are special  
\M  # No magic: almost no characters are special
\V  # Very no magic: only backslash is special
```

The very magic flag provides future-proofing for regex patterns and consistency.

## Tuesday Jan 27 2026 Native Neovim list continuation

### 23] Successful implementation summary
Replacement of `autolist.nvim` with a robust native-integrated Lua solution.

#### Overview
We replaced the aging `autolist.nvim` with a custom Lua implementation in `after/ftplugin/markdown.lua`. This solution uses atomic buffer manipulation APIs (`nvim_buf_set_lines`) to ensure stability and compatibility with completion engines like `blink.cmp`.

#### Implementation Logic
The core logic resides in a buffer-local `<CR>` mapping that performs the following:
1. **Marker Detection:** Identifies unordered bullets (`-`, `*`, `+`), ordered numbers (`1.`, `1)`), and checkboxes (`[ ]`).
2. **Ordered Incrementing:** Automatically calculates and inserts the next number in a sequence.
3. **Checkbox Persistence:** Carries over checkbox markers to new lines.
4. **Auto-Termination:** Cleanly ends the list if Enter is pressed on an empty marker.

#### Code Reference
```lua
-- Robust Pure API list continuation
vim.keymap.set('i', '<CR>', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  
  -- Content before and after the cursor
  local prefix = line:sub(1, col)
  local suffix = line:sub(col + 1)

  -- 1. Pattern matching for various list types
  local indent, marker, punct, checkbox
  
  -- Match different marker styles:
  indent, marker, punct, checkbox = prefix:match('^(%s*)(%d+)([.)])%s*(%[[ xX]%]%s*)')
  if not marker then indent, marker, punct = prefix:match('^(%s*)(%d+)([.)])%s+') end
  if not marker then indent, marker, checkbox = prefix:match('^(%s*)([-*+])%s*(%[[ xX]%]%s*)') end
  if not marker then indent, marker = prefix:match('^(%s*)([-*+])%s+') end

  -- Fallback if not in a list
  if not marker then
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
  end

  -- 2. Check for termination (Enter on empty item)
  local is_empty = false
  if checkbox then
    if prefix:match('^%s*[-*+]%s*%[[ xX]%]%s*$') or prefix:match('^%s*%d+[.)]%s*%[[ xX]%]%s*$') then
      is_empty = true
    end
  else
    if prefix:match('^%s*[-*+]%s*$') or prefix:match('^%s*%d+[.)]%s*$') then
      is_empty = true
    end
  end

  if is_empty then
    vim.api.nvim_set_current_line(indent .. suffix)
    vim.api.nvim_buf_set_lines(0, row, row, false, { indent })
    vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
    return
  end

  -- 3. Construct next marker
  local next_marker
  if marker:match('%d+') then
    next_marker = indent .. (tonumber(marker) + 1) .. punct .. ' ' .. (checkbox or '')
  else
    next_marker = indent .. marker .. ' ' .. (checkbox or '')
  end

  -- 4. Atomically insert the new line and set cursor
  vim.api.nvim_set_current_line(prefix)
  vim.api.nvim_buf_set_lines(0, row, row, false, { next_marker .. suffix })
  vim.api.nvim_win_set_cursor(0, { row + 1, #next_marker })
end, { buffer = true, desc = 'Smart list continuation' })
```

### 28] Explanation of Lua pattern matching
The line you highlighted uses **Lua Patterns**, which are specific to the Lua language. While they look similar to standard Regular Expressions (regex), they are a smaller, faster, and slightly different implementation unique to Lua.

#### Is it Vim or Lua specific?
It is **Lua-specific**. Neovim has its own regex engine (used in commands like `:%s/find/replace/`), but when you are writing logic inside a `.lua` file using `string:match()` (`function`), you are using Lua's native pattern engine.

#### Breakdown of the pattern: `'^(%s*)(%d+)([.)])%s+'`

| Symbol   | Technical Term                 | Description                                                                                                                      |
| :------- | :----------------------------- | :------------------------------------------------------------------------------------------------------------------------------- |
| `^`      | **Anchor**                     | Forces the match to start at the very beginning of the `prefix` (`string`).                                                      |
| `(%s*)`  | **Capture Group** (`%s` class) | Matches 0 or more whitespace characters (spaces/tabs). Captured into the `indent` (`string`) variable.                           |
| `(%d+)`  | **Capture Group** (`%d` class) | Matches 1 or more digits. Captured into the `marker` (`string`) variable.                                                        |
| `([.)])` | **Capture Group** (Set)        | Matches exactly one character that is either a literal `.` or a literal `)`. Captured into `punct` (`string`).                   |
| `%s+`    | **Quantifier**                 | Matches 1 or more whitespace characters *after* the punctuation. It isn't in parentheses, so it is "matched" but not "captured." |

#### Key differences from standard Regex:
*   **Escape Character:** Lua uses the percent sign `%` (`string`) as an escape character (e.g., `%d` for digits) instead of the backslash `\` used in Vim or JavaScript.
*   **Syntactic Sugar:** The colon syntax `prefix:match(...)` is **syntactic sugar** (`code`) for `string.match(prefix, ...)`. It automatically passes `prefix` as the first argument to the function.

This specific pattern ensures that `1. Hello` is recognized as a list, but a standalone number like `In 1999, it happened` is ignored because it lacks the trailing punctuation and space.

### 29] Lua Character Sets and Pattern syntax
The `[]` (`string`) symbols in Lua patterns define a **Character Class** (frequently called a **Set**). It tells Lua: "Match exactly one character, as long as it is one of the characters inside these brackets."

#### How it compares to Regex
While it is similar to standard regex, there are two very important differences in Lua's implementation:

1.  **No Alternation Pipe:** In standard regex, you might write `(\.|\))` to match a dot OR a parenthesis. In Lua patterns, the `|` (`string`) character has no special meaning and is not used for "OR." Instead, the `[]` (`string`) brackets handle the "OR" logic implicitly. 
    - `[.)]` (`string`) means "Match `.` OR `)`."
    - If you wrote `[.|)]` in Lua, it would match a dot, a pipe, or a parenthesis.

2.  **Escaping inside Sets:** In standard regex, a `.` (`string`) usually means "any character" and must be escaped (`\.`) to mean a literal dot. In Lua patterns:
    - **Outside** a set, `.` (`string`) is a magic character (matches anything).
    - **Inside** a set `[]`, most magic characters (including `.`, `+`, `*`, `-`) automatically lose their special meaning and are treated as literals.
    - Therefore, `[.)]` (`string`) safely matches a literal period or a literal closing parenthesis without needing percent-escapes.

#### Syntactic Sugar Note
When we use `([.)])` (`string`), we are combining a **Capture Group** (`()`) with a **Character Class** (`[]`). 
- The `[]` (`string`) defines *what* to match.
- The `()` (`string`) tells Lua to *capture* that specific match and assign it to our variable `punct` (`string`).

This is a very efficient way to handle different list styles like `1.` and `1)` in a single line of code.

### 30] Explaining the checkbox pattern
The pattern `(%[[ xX]%]%s*)` (`string`) is a great example of how Lua patterns handle "magic" characters that need to be treated as literals.

#### Breakdown of the pattern:

| Symbol      | Technical Term        | Description                                                                                                                                                             |
| :---------- | :-------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `(` ... `)` | **Capture Group**     | Everything inside the parentheses is captured into the `checkbox` (`string`) variable.                                                                                  |
| `%[`        | **Escaped Character** | Matches a literal left square bracket `[`. In Lua, `[` is a magic character used to start a set, so the `%` (`string`) "escapes" it.                                     |
| `[ xX]`     | **Character Set**     | Matches exactly one character that is either a **space**, a lowercase **x**, or an uppercase **X**. This allows us to detect both empty and completed checkboxes.       |
| `%]`        | **Escaped Character** | Matches a literal right square bracket `]`. Like the left bracket, it must be escaped with `%` (`string`) to be treated as a literal.                                   |
| `%s*`       | **Quantifier**        | Matches zero or more whitespace characters following the checkbox.                                                                                                      |

#### Why the Escaping is Different
In standard regex, you might see `\[[ xX]\]`. Because Lua uses `%` (`string`) as its escape character instead of `\`, the syntax becomes `%[[ xX]%]` (`string`).

#### Syntactic Sugar and Logical Flow
When this pattern is combined with the marker pattern, the logic flows like this:
1. Find the indentation.
2. Find the marker (like `-`).
3. **Optional Match:** The code then looks for this checkbox pattern. Because we use `prefix:match(...)`, if the checkbox isn't there, the variable will simply be `nil` (`boolean`), and our script knows it's a "simple" list item.

This is a very powerful way to handle **syntactic sugar** (`code`) like checkboxes in Markdown without needing multiple complex functions.

### 36] CLI directory management tips
----------------------------------

You can achieve this using **Variables** (`string`), the **Directory Stack**, or a built-in shortcut.

#### 1. Using Variables
You can assign the output of `pwd` (`command`) or the value of the `$PWD` (`variable`) to a custom name.

```bash
target=$PWD    # Saves current path to 'target' (variable)
cd /tmp        # Change directory
cd "$target"   # Returns to the saved path
```

#### 2. The `cd -` Shortcut
If you only need to toggle between the **current** and **previous** directory, use the hyphen:

```bash
cd /some/very/long/path
cd /tmp
cd -           # Jumps back to /some/very/long/path
```

#### 3. Using `pushd` and `popd`
For a more robust approach, use the **Directory Stack** (`stack`). This "pushes" your current location onto a list so you can "pop" back to it later.

```bash
pushd .        # Pushes current directory onto the stack
cd /etc
popd           # Returns to the directory at the top of the stack
```

**Syntactic Sugar:** In many shells, `cd -` is **syntactic sugar** (`code`) for `cd "$OLDPWD"`.

### 39] Explaining Git Stashing
-----------------------------

To **Stash** something in Git means to take your uncommitted changes (both in the **Working Directory** (`folder`) and the **Staging Area** (`index`)) and put them into a temporary storage area (the **Stash Stack** (`stack`)).

#### 1. Why use it?
It is most useful when you are in the middle of a task and need to switch branches or perform a quick fix, but your current code is too messy or incomplete to **Commit** (`command`).

#### 2. Common Operations

| Command           | Technical Action                                                                                             |
| :---------------- | :----------------------------------------------------------------------------------------------------------- |
| `git stash`       | Saves your changes and reverts your working directory to match the `HEAD` (`pointer`) commit.                |
| `git stash list`  | Displays all stashed changes in the stack.                                                                   |
| `git stash pop`   | Removes the most recent stash from the stack and re-applies it to your code.                                 |
| `git stash apply` | Re-applies the changes but keeps them in the stash stack for future use.                                     |

#### 3. Key Concepts
*   **Dirty State:** A working directory with uncommitted changes. Stashing "cleans" this state.
*   **Last In, First Out (LIFO):** The stash operates as a stack. The most recent thing you stashed is the first thing that `pop` will return.
*   **Untracked Files:** By default, `git stash` only saves tracked files. To include new files you haven't added yet, you must use the `-u` (`flag`) (include-untracked).

### 46] Deep Dive into LSP and Clipboard Logic
--------------------------------------------

I have analyzed the technical implementations of both the LSP strategy and clipboard handling. Here is a detailed breakdown of the logic and the trade-offs between your current setup and the `kickstart.nvim` base.

#### 1. LSP Strategy: Automated Handlers vs. Explicit Configuration

The primary difference lies in how Neovim "talks" to the language servers installed on your machine.

**Your Config (Automated Handlers)**
In `lua/core/nvim-lspconfig.lua`, you use the **Handlers** (`table`) pattern provided by `mason-lspconfig`. 
*   **Logic:** You define a default setup function and pass it to `handlers`. 
*   **Behavior:** Whenever you install a new server via `:Mason`, this logic automatically detects it and runs `.setup()` with your global capabilities. 
*   **Benefit:** Extremely low maintenance. You don't have to touch your Lua code when adding a new language; just install the server and restart.
*   **Technical Detail:** You've included a `client_supports_method` helper. This is a robust piece of logic that checks if a server supports a feature (like `documentHighlight`) before creating an **autocommand** (`autocmd`) for it, preventing errors in Neovim `0.10` and `0.11`.

**Kickstart (Explicit Enable)**
Kickstart uses the new "static" configuration style introduced in Neovim `0.11`:
*   **Logic:** It defines a `servers` (`table`) and manually iterates through it using a `for` loop, calling `vim.lsp.config` and `vim.lsp.enable`.
*   **Behavior:** If you install a server via Mason but don't add it to the `servers` table in `init.lua`, it will **not** activate.
*   **Benefit:** Higher visibility. You can see exactly which servers are enabled and provide specific, granular overrides for each one in a single place.

---

#### 2. Clipboard Handling: The "unnamedplus" Conflict

Clipboard handling is a common source of performance issues in Neovim, and your config takes a very different stance than Kickstart.

**Your Config (Isolation)**
In `lua/alpha/options.lua`, you have `vim.opt.clipboard = ''`.
*   **Logic:** This keeps Neovim's internal **registers** (like `"` and `*`) completely separate from your system clipboard (macOS Command+C/V).
*   **Why do this?** It prevents "clipboard pollution." If you delete a line in Neovim, it won't overwrite the text you just copied from a web browser. It also makes yanking/pasting slightly faster because Neovim doesn't have to communicate with the system's clipboard provider on every operation.

**Kickstart (Integration & Optimization)**
Kickstart defaults to `vim.o.clipboard = 'unnamedplus'`.
*   **Logic:** Every time you `y` (yank) or `d` (delete), the text is automatically sent to your system clipboard.
*   **The "Performance Trick":** Notice Kickstart uses `vim.schedule(function() ... end)`.
    *   **Technical Reason:** The system clipboard is an external process. If Neovim tries to connect to it during startup, it can cause a 100ms–500ms delay (lag) before you see your text. 
    *   **Syntactic Sugar:** `vim.schedule` is **syntactic sugar** (`code`) for "run this code as soon as the main editor UI is ready." This allows Neovim to start instantly and then enable the clipboard in the background.

---

#### Summary Table

| Feature       | Your Implementation     | Kickstart Implementation   | Technical Driver                    |
| :------------ | :---------------------- | :------------------------- | :---------------------------------- |
| **LSP**       | Dynamic Handlers        | Explicit Enable Loop       | Maintainability vs. Control         |
| **Clipboard** | Internal Registers Only | Scheduled `unnamedplus`    | Registry Privacy vs. OS Integration |
| **Setup**     | Modular (`require`)     | Monolithic (Inline)        | Scalability vs. Readability         |

### 68] Vim motions for changing within quotes
-----------------------------------------------

In your current setup, the motion to "change within quotes" is handled by **Neovim's built-in logic** and enhanced by **`mini.ai`** (`plugin`).

#### 1. The Standard Motion
*   **`ci"`**: **[C]hange [I]nside ["]double-quote**.
*   **`ci'`**: **[C]hange [I]nside [']single-quote**.
*   **`ciq`**: **[C]hange [I]nside [q]uote** (This is a special **Syntactic Sugar** (`code`) provided by `mini.ai` that targets the nearest quote of any type).

#### 2. `mini.ai` Enhancements (Targeting Content)
Because you have `mini.ai` active, you have access to "Smart Text Objects." This allows you to target quotes that are not currently under your cursor:
*   **`cin"`**: Change inside the **[n]ext** double quote.
*   **`cil"`**: Change inside the **[l]ast** (previous) double quote.

#### 3. `mini.surround` (Targeting the Quotes themselves)
While `mini.ai` helps you change the **text inside**, `mini.surround` is used to change the **quotes themselves**:
*   **`sd"`**: **[S]urround [D]elete ["]quote**. (Removes the quotes but keeps the text).
*   **`sr"'`**: **[S]urround [R]eplace ["] with [']**. (Swaps double quotes for single quotes).

#### Summary of Roles
| Plugin            | Action Type             | Example                          |
| :---------------- | :---------------------- | :------------------------------- |
| **`mini.ai`**      | **Text Object** (`code`) | `ci"` (Change the words inside)  |
| **`mini.surround`** | **Surround** (`code`)    | `sr"'` (Change the quote marks) |

### 69] Explaining text objects and delimiters
--------------------------------------------

#### 1. Is "Delimiter" the correct term?
Yes, **Delimiter** (`technical_term`) is very common. In official Vim documentation, these are often called **Surrounding Characters** or **Enclosed Text Objects** (`technical_term`).

#### 2. Does `ci` work with other delimiters?
Absolutely. The `ci` (**Change Inside**) logic works with a wide variety of paired characters.

| Command         | Target Delimiter                     |
| :-------------- | :----------------------------------- |
| `ci(` or `cib`  | Parentheses `()`                     |
| `ci[`           | Square brackets `[]`                 |
| `ci{` or `ciB`  | Curly braces `{}`                    |
| `cit`           | XML/HTML Tags (e.g., `<p>text</p>`)  |
| `ci<`           | Angle brackets `<>`                  |

### 70] Summary of "Smart" text objects in your config
-----------------------------------------------------

I have confirmed that your current **`mini.ai`** (`plugin`) configuration uses the standard defaults, which already includes very powerful "generic" targets. 

#### 1. The "Automatic" text objects
You don't need a single key for "everything," because `mini.ai` has already grouped them into logical sets:

*   **`b` (Balanced):** Covers `(`, `)`, `[`, `]`, `{`, `}`.
    - `cib` will change inside the closest of any of these brackets.
*   **`q` (Quote):** Covers `"`, `'`, `` ` ``.
    - `ciq` will change inside the closest of any of these quotes.

#### 2. Comparison of Operators

| Logic               | Command | Result                                       |
| :------------------ | :------ | :------------------------------------------- |
| **Standard Vim**    | `ci"`   | Targets only double quotes.                  |
| **`mini.ai` Sugar** | `ciq`   | Targets double, single, or backticks.        |
| **Standard Vim**    | `ci(`   | Targets only parentheses.                    |
| **`mini.ai` Sugar** | `cib`   | Targets parentheses, square, or curly braces.|

### 71] Using `mini.surround` to add delimiters
--------------------------------------------

To "surround" a word with brackets using your current **`mini.surround`** (`plugin`) configuration, you use the **`sa`** (**Surround Add**) operator.

#### 1. The Command Sequence
To change `word` into `[word]`, place your cursor anywhere on the word and type:

`saiw]` (`key_sequence`)

#### 2. Technical Breakdown
*   **`sa`**: The **Surround Add** (`operator`).
*   **`iw`**: The **Inner Word** (`text_object`). This tells Neovim *what* to surround.
*   **`]`**: The **Delimiter** (`technical_term`). This tells Neovim *which* character to use.

#### 3. Padding Logic (The `[` vs `]` distinction)
`mini.surround` has a clever feature for handling whitespace:
*   **`saiw]`**: Results in `[word]` (No extra spaces).
*   **`saiw[`**: Results in `[ word ]` (Includes **Space Padding** (`technical_term`)).

#### Summary table of Surround Actions

| Action      | Command   | Technical Result     |
| :---------- | :-------- | :------------------- |
| **Add**     | `saiw]`   | `word` → `[word]`    |
| **Delete**  | `sd]`     | `[word]` → `word`    |
| **Replace** | `sr](`    | `[word]` → `(word)`  |

### 73] Surrounding a single character with `mini.surround`
--------------------------------------------------------

To surround a single letter with parentheses using your current configuration, you have two primary methods.

#### 1. Using a Motion (Normal Mode)
You can use the `sa` (**Surround Add**) operator followed by a **Motion** (`technical_term`) that covers exactly one character. The most common motion for this is `l` (right).

**Command:** `sal)` (`key_sequence`)

*   **`sa`**: Surround Add (`operator`)
*   **`l`**: Move right (`motion`). Since it moves one character, it defines the target as the current letter.
*   **`)`**: Parentheses (`delimiter`).

#### 2. Using Visual Mode (Recommended for precision)
If you find motions tricky for single letters, you can use **Visual Mode** (`mode`) to explicitly select the letter first.

**Command:** `vsa)` (`key_sequence`)

*   **`v`**: Enter visual mode (selects the current character).
*   **`sa`**: Trigger the Surround Add operator.
*   **`)`**: Select the parenthesis delimiter.

#### 3. Technical Detail: Space Padding
As with words, the choice of delimiter determines the padding:
*   `sal)` results in `(x)`
*   `sal(` results in `( x )` (**Syntactic Sugar** (`code`) for automated padding).

## Wednesday Jan 28 2026 Linter rule customization

### 84] Integrating linter rule overrides
--------------------------------------------

I have analyzed the best way to integrate these overrides into your modular configuration.

#### Proposed Changes for `lua/core/nvim-lint.lua`

I recommend inserting the following logic into the `config` (`function`) block. This ensures that the arguments are applied only when the `nvim-lint` plugin is initialized.

```lua
    local lint = require 'lint'
    
    -- 1. Assign linters to filetypes
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
    }

    -- 2. Customize markdownlint arguments
    -- We access the 'markdownlint' object (table) and modify its 'args' (table)
    local markdownlint = lint.linters.markdownlint
    markdownlint.args = {
      '--disable',
      'MD012', -- multiple-blanks: No multiple consecutive blank lines
      'MD030', -- list-marker-space: Spaces after list markers
      '--',    -- Sentinel (string) indicating end of flags; files follow
    }

    -- 3. Create the autocommand group (existing logic)
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    -- ... rest of your file ...
```

#### Technical Breakdown
*   **`markdownlint.args`**: This is a **Table** (`table`) of strings that `nvim-lint` passes to the shell when it executes the linter.
*   **`--disable`**: This is the **Flag** (`string`) recognized by the `markdownlint` CLI to ignore specific rules.
*   **`--`**: This is a common CLI convention (Sentinel) that tells the program to stop looking for flags and treat all subsequent arguments as file paths. This is important because `nvim-lint` will append the current file path to the end of this list.

#### Alternative: Project-wide Configuration
If you prefer not to "hardcode" these rules in your Neovim config, you can achieve the same result by creating a file named `.markdownlint.json` in your project root with this content:
```json
{
  "MD012": false,
  "MD030": false
}
```
Neovim will automatically pick this up, and it has the benefit of working for other people who might collaborate on your project.

### 86] Commands for converting text to uppercase
-------------------------------------------------

In Neovim, making a word uppercase is performed using an **Operator** (`technical_term`) combined with a **Motion** or **Text Object** (`technical_term`).

#### 1. The Operator Method (Normal Mode)
The standard command to convert text to uppercase is **`gU`**. To target a word, you use the following sequences:

| Command | Technical Result                                                      |
| :------ | :-------------------------------------------------------------------- |
| `gUiw`  | Uppercase **inner word** (does not include surrounding whitespace).   |
| `gUaw`  | Uppercase **a word** (includes trailing whitespace).                  |
| `gUU`   | Uppercase the **entire current line**.                                |

#### 2. The Visual Mode Method
If you prefer selecting the text first:
1.  **`viw`**: Visually select the inner word.
2.  **`U`**: Convert the selection to uppercase.

#### 3. The "Toggle" Shortcut
If you only need to change the case of a single character or a few characters, you can use:
*   **`~`**: Toggles the case (lower to upper, upper to lower) of the character under the cursor and moves the cursor right.

#### Technical Summary
*   **`gU`**: The **Uppercase Operator** (`code`).
*   **`gu`**: The **Lowercase Operator** (`code`).
*   **`iw`**: The **Inner Word Text Object** (`code`).
