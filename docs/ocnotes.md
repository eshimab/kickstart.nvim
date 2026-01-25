# nvim config updates

### Summary of Major Changes in Kickstart (Compared to Your Config)
Kickstart has evolved significantly since many users forked it. It now prioritizes modern, lightweight plugins and has streamlined its LSP/completion setup. Your config includes many additional plugins (e.g., Harpoon, Neo-tree, DAP), which are customizations beyond the base kickstart. The core differences are in completion (switched to Blink), LSP tooling (Mason updates), and indentation detection.

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
| **Gitsigns**         | `lewis6991/gitsigns.nvim`                                      | `lewis6991/gitsigns.nvim`                                                     | Same.                                                             |
| **Which-Key**        | `folke/which-key.nvim`                                         | `folke/which-key.nvim`                                                        | **[4]**                                                           |
| **Colorscheme**      | `folke/tokyonight.nvim`                                        | `folke/tokyonight.nvim`                                                       | Same.                                                             |
| **Todo Comments**    | `folke/todo-comments.nvim`                                     | `folke/todo-comments.nvim`                                                    | Same.                                                             |
| **Mini Plugins**     | `echasnovski/mini.nvim` (ai, surround, statusline)             | `echasnovski/mini.nvim` (same)                                                | Same.                                                             |
| **Lazydev**          | `folke/lazydev.nvim`                                           | `folke/lazydev.nvim`                                                          | Same.                                                             |
| **Telescope**        | `nvim-telescope/telescope.nvim` with deps                      | `nvim-telescope/telescope.nvim` with deps                                     | Same.                                                             |
| **New in Kickstart** | -                                                              | (Your extras: Harpoon, Neo-tree, UFO, Autopairs, Indent-blankline, Lint, DAP) | **[5]**                                                           |

#### Plugin Differences Notes

1. Kickstart replaced vim-sleuth with guess-indent for better auto-detection. If you're happy with vim-sleuth, no need to change; guess-indent is more modern but similar.
2. Kickstart fully switched to Blink.cmp as the default (faster, simpler than nvim-cmp). You have both installed—consider removing nvim-cmp to avoid conflicts and match kickstart. Blink is now the recommended choice.
3. Kickstart updated to the new `mason-org` namespace (the original maintainer moved). Your config uses the old `williamboman`—update to avoid deprecation warnings.
4. Same, but spec groups updated (e.g., kickstart uses `<leader>s` for search, you have more groups).
5. Kickstart removed these from defaults to stay minimal. Keep them if you use them.

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

4. **Fix Suggestions**
   1. **If Cached Error**: Clearing caches and reloading should resolve it, as the manual require works.
   2. **If Unpack Issue**: Add error handling to the loop: `for _, km in ipairs(remap.telescope_keymaps or {}) do if #km == 4 then vim.keymap.set(unpack(km)) end end` to skip bad entries.
   3. **Fallback**: If issues persist, revert Telescope config to inline keymaps (remove the require and loop) and re-add the import later.
   4. **Ensure Correct Code in init.lua**: Confirm your Telescope config has:
      ```lua
      config = function()
        local remap = require 'remap'
        if remap and remap.telescope_keymaps then
          for _, km in ipairs(remap.telescope_keymaps) do
            vim.keymap.set(unpack(km))
          end
        end
        -- Rest of config...
      end,
      ```

5. **Post-Fix Verification**
   - Reload and test `:Telescope help_tags` and `<leader>sh`.
   - If fixed, the import works; if not, share the new error details.

6. **Questions for Clarification**
   1. After clearing caches and reloading, does the error still occur?
   2. What does `:lua local r = require 'remap'; print(#r.telescope_keymaps)` return (should be the number of keymaps, e.g., 7)?
   3. Did you modify the Telescope config in `init.lua` recently? Can you confirm the exact code around line 110?

This plan should isolate whether it's a cache issue or a real problem in the loop. Start with clearing caches, then test the table contents. If you provide the results, I can refine further. If it's still broken, we may need to debug the Telescope config directly.

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

This plan covers methods to list keymaps without changes—let me know your preference (e.g., which method or subset), and I can refine or provide exact commands! If you encounter issues, share the output of `:map` for debugging.

### Find and Replace in Neovim

#### Case-Sensitive Separate Commands
Replace both variations with individual commands:

```vim
:%s/v_eq_n2/v02_n2/g
:%s/V_EQ_N2/v02_n2/g
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
