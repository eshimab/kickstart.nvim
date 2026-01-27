-- Native Neovim list continuation for Markdown
-- vim: ts=2 sts=2 sw=2 et

-- 'r' - Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- 'o' - Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
-- 'n' - When formatting text, recognize numbered lists.
-- 'j' - Where it makes sense, remove a comment leader when joining lines.
-- We keep these for Normal mode 'o'/'O' support, but our imap <CR> will override Insert mode behavior.
vim.opt_local.formatoptions:append('ronj')

-- Define list markers as "comments" so Neovim knows to continue them
vim.opt_local.comments = {
  'b:-',
  'b:*',
  'b:+',
  'b:1.',
  'n:>', -- Blockquotes
}

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
  
  -- Try to match different marker styles:
  -- Ordered with checkbox: "  1. [ ] "
  indent, marker, punct, checkbox = prefix:match('^(%s*)(%d+)([.)])%s*(%[[ xX]%]%s*)')
  -- Ordered simple: "  1. "
  if not marker then
    indent, marker, punct = prefix:match('^(%s*)(%d+)([.)])%s+')
  end
  -- Unordered with checkbox: "  - [ ] "
  if not marker then
    indent, marker, checkbox = prefix:match('^(%s*)([-*+])%s*(%[[ xX]%]%s*)')
  end
  -- Unordered simple: "  - "
  if not marker then
    indent, marker = prefix:match('^(%s*)([-*+])%s+')
  end

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
    -- Clear current line marker and move to next line
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
  -- Current line keeps prefix, new line gets next_marker + suffix
  vim.api.nvim_set_current_line(prefix)
  vim.api.nvim_buf_set_lines(0, row, row, false, { next_marker .. suffix })
  vim.api.nvim_win_set_cursor(0, { row + 1, #next_marker })
end, { buffer = true, desc = 'Smart list continuation' })
