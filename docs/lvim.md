<!-- vim: ts=2 sts=2 st=2 et -->


# LazyVim Config

## lvim/plugins/extras

### lvim/plugins/extras/lang

#### markdown.lua

Based on LazyVim markdown configuration file, here are the markdown plugins they use:

##### conform.nvim
- **Plugin repo:** https://github.com/stevearc/conform.nvim
- **Capabilities:** Code formatting with support for markdown formatters
- **Configuration:**
```lua
{
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    },
    formatters_by_ft = {
      ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
    },
  },
},
```

##### mason.nvim (markdown tools)
- **Plugin repo:** https://github.com/mason-org/mason.nvim
- **Capabilities:** Package manager for ensuring markdown tools are installed
- **Configuration:**
```lua
{
  "mason-org/mason.nvim",
  opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
},
```

##### none-ls.nvim (markdown diagnostics)
- **Plugin repo:** https://github.com/nvimtools/none-ls.nvim
- **Capabilities:** LSP diagnostics integration for markdownlint
- **Configuration:**
```lua
{
  "nvimtools/none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.markdownlint_cli2,
    })
  end,
},
```

##### nvim-lint (markdown linting)
- **Plugin repo:** https://github.com/mfussenegger/nvim-lint
- **Capabilities:** External linter integration for markdown
- **Configuration:**
```lua
{
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint-cli2" },
    },
  },
},
```

##### nvim-lspconfig (LSP server)
- **Plugin repo:** https://github.com/neovim/nvim-lspconfig
- **Capabilities:** LSP server configuration for markdown
- **Configuration:**
```lua
{
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {},
    },
  },
},
```

##### markdown-preview.nvim
- **Plugin repo:** https://github.com/iamcco/markdown-preview.nvim
- **Capabilities:** Browser-based markdown preview
- **Configuration:**
```lua
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  config = function()
    vim.cmd([[do FileType]])
  end,
},
```

##### render-markdown.nvim
- **Plugin repo:** https://github.com/MeanderingProgrammer/render-markdown.nvim
- **Capabilities:** In-editor markdown rendering (similar to markview.nvim)
- **Configuration:**
```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    Snacks.toggle({
      name = "Render Markdown",
      get = require("render-markdown").get,
      set = require("render-markdown").set,
    }):map("<leader>um")
  end,
},
```

**Important observation:** LazyVim does NOT include any dedicated list completion/autocomplete plugin. None of these plugins provide automatic list continuation functionality like what you described (auto-inserting `2. ` after `1. ` when pressing return).

For list completion in LazyVim, you would need to add a separate plugin like `autolist.nvim` or implement custom keybindings/autocommands.
