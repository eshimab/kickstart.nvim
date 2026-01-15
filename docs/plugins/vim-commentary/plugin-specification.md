# vim-commentary Plugin Specification Example

This document provides a comprehensive example of how to add the [vim-commentary](https://github.com/tpope/vim-commentary) plugin to your lazy.nvim configuration with all available properties explained.

## Complete Plugin Specification

Here's how you can add vim-commentary to your lazy.nvim configuration with all available properties:

```lua
{
  'tpope/vim-commentary',
  
  -- Basic properties
  enabled = true,                    -- Whether the plugin should be loaded
  lazy = false,                      -- Load immediately (default for simple plugins)
  dir = nil,                        -- Custom directory (not needed for GitHub plugins)
  url = nil,                        -- Custom URL (not needed when using repo name)
  dev = false,                      -- Whether to use local development version
  branch = 'master',                -- Git branch to use (optional)
  tag = nil,                        -- Git tag to checkout (optional)
  commit = nil,                     -- Git commit hash to checkout (optional)
  version = nil,                    -- Version string (optional)
  
  -- Loading triggers (choose one or multiple)
  event = nil,                      -- Events that trigger loading (not needed for this plugin)
  cmd = nil,                        -- Commands that trigger loading (not needed for this plugin)
  ft = nil,                         -- Filetypes that trigger loading (not needed for this plugin)
  keys = nil,                       -- Key mappings that trigger loading (not needed for this plugin)
  module = false,                   -- Load when a Lua module is required
  priority = 50,                    -- Plugin loading priority (lower loads first)
  
  -- Dependencies
  dependencies = {},                -- Other plugins this plugin depends on
  optional = false,                 -- Whether this plugin is optional
  
  -- Configuration
  config = function()              -- Function to configure the plugin
    -- vim-commentary doesn't require configuration, but if you wanted to customize it:
    -- vim.g.commentary_map_keys = 0  -- Example: disable default mappings
  end,
  opts = {},                        -- Plugin options (passed to setup if plugin uses lazy.nvim spec)
  
  -- Build/installation
  build = nil,                      -- Build command (not needed for vim-commentary)
  cond = nil,                       -- Condition to determine if plugin should be installed
  name = nil,                       -- Plugin name (inferred from URL)
  
  -- Advanced properties
  init = function()                 -- Function to run before plugin is loaded
    -- Could set up global variables here if needed
  end,
  opts_pre = function()             -- Function to modify opts before config
    return {}
  end,
  config_pre = function()           -- Function to run before main config
    -- Pre-configuration setup
  end,
  config_post = function()          -- Function to run after main config
    -- Post-configuration setup
  end,
  post = function()                  -- Function to run after plugin is loaded and configured
    -- vim-commentary works out of the box, no post-setup needed
  end,
  
  -- Plugin management
  pin = false,                      -- Whether to pin plugin to current version
  dependencies_pre = function()      -- Function to run before dependencies are loaded
    return {}
  end,
}
```

## Simplified Version for Practical Use

Since vim-commentary is a simple, zero-configuration plugin, here are practical versions you should use:

### Minimal Configuration
```lua
{
  'tpope/vim-commentary',
  event = 'VeryLazy',  -- Load when Neovim is ready
}
```

### Even Simpler
```lua
'tpove/vim-commentary'
```

## Integration with Current Configuration

Add this to your plugin table in `/Users/eshim/.config/nvim/init.lua` around line 57 (near vim-sleuth):

```lua
-- NOTE: Plugin: vim-sleuth
'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

-- NOTE: Plugin: vim-commentary
{ 'tpope/vim-commentary', event = 'VeryLazy' }, -- Comment/uncomment with gcc, gc, etc.
```

## Key Features of vim-commentary

### Core Functionality
- `gcc` - Toggle comment on current line (takes a count)
- `gc` - Toggle comment on motion (e.g., `gcap` for paragraph)
- Visual mode `gc` - Toggle comment on selection
- `gcgc` - Uncomment adjacent commented lines

### Advanced Usage
- Use as a command with range: `:7,17Commentary`
- Use with global commands: `:g/TODO/Commentary`
- Works with any filetype that has proper `'commentstring'` set

### Customization Example
If you need to add support for a custom filetype:

```lua
-- Add to your vim configuration or in a FileType autocmd
autocmd FileType apache setlocal commentstring=#\ %s
```

## Properties Explanation

### Loading Triggers
Choose one or more of these properties to control when the plugin loads:

- `event` - Events that trigger loading (e.g., `'VeryLazy'`, `'InsertEnter'`)
- `cmd` - Commands that trigger loading
- `ft` - Filetypes that trigger loading
- `keys` - Key mappings that trigger loading

### Configuration Options
- `config` - Function to configure the plugin (most common)
- `opts` - Plugin options (passed automatically to setup function)
- `init` - Function to run before plugin is loaded

### Version Control
- `branch` - Git branch to use
- `tag` - Git tag to checkout
- `commit` - Git commit hash to checkout
- `pin` - Whether to pin plugin to current version

## Plugin Characteristics

vim-commentary is:
- **Lightweight**: ~100 lines of code
- **Zero-configuration**: Works out of the box
- **No dependencies**: Standalone plugin
- **Immediate**: No setup required after installation

## Alternative Approach

For maximum customization, you could create a separate plugin configuration file:

`/Users/eshim/.config/nvim/lua/plugins/vim-commentary.lua`:
```lua
return {
  'tpope/vim-commentary',
  event = 'VeryLazy',
  keys = {
    { 'gc', mode = { 'n', 'v' }, desc = 'Toggle comment' },
    { 'gcc', mode = 'n', desc = 'Toggle line comment' },
  },
}
```

Then in your main configuration, ensure this file is loaded by your lazy.nvim setup.