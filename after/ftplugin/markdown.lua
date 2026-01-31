-- Native Neovim list continuation for Markdown
-- vim: ts=2 sts=2 sw=2 et

-- 'r' - Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- 'o' - Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
-- 'n' - When formatting text, recognize numbered lists.
-- 'j' - Where it makes sense, remove a comment leader when joining lines.
-- We keep these for Normal mode 'o'/'O' support, but our imap <CR> will override Insert mode behavior.
vim.opt_local.formatoptions:append 'ronj'

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
  local indent, marker, punct, checkbox, padding
  -- Try to match different marker styles:
  -- Ordered with checkbox: "  1. [ ] "
  indent, marker, punct, checkbox, padding = prefix:match '^(%s*)(%d+)([.)])%s*(%[[ xX]%])(%s+)'
  -- Ordered simple: "  1. "
  if not marker then
    indent, marker, punct, padding = prefix:match '^(%s*)(%d+)([.)])(%s+)'
  end
  -- Unordered with checkbox: "  - [ ] "
  if not marker then
    indent, marker, checkbox, padding = prefix:match '^(%s*)([-*+])%s*(%[[ xX]%])(%s*)'
  end
  -- Unordered simple: "  - "
  if not marker then
    indent, marker, padding = prefix:match '^(%s*)([-*+])(%s+)'
  end
  if checkbox then
    checkbox = ' ' .. checkbox
  end

  -- Fallback if not in a list
  if not marker then
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
  end

  -- 2. Check for termination (Enter on empty item)
  local is_empty = false
  if checkbox then
    if prefix:match '^%s*[-*+]%s*%[[ xX]%]%s*$' or prefix:match '^%s*%d+[.)]%s*%[[ xX]%]%s*$' then
      is_empty = true
    end
  else
    if prefix:match '^%s*[-*+]%s*$' or prefix:match '^%s*%d+[.)]%s*$' then
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
  if marker:match '%d+' then
    next_marker = indent .. (tonumber(marker) + 1) .. punct .. (checkbox or '') .. padding
  else
    next_marker = indent .. marker .. (checkbox or '') .. padding
  end

  -- 4. Atomically insert the new line and set cursor
  -- Current line keeps prefix, new line gets next_marker + suffix
  vim.api.nvim_set_current_line(prefix)
  vim.api.nvim_buf_set_lines(0, row, row, false, { next_marker .. suffix })
  vim.api.nvim_win_set_cursor(0, { row + 1, #next_marker })
end, { buffer = true, desc = 'Smart list continuation' })

-- ================================ AUTO FORMAT MARKDOWN TABLES =========================
-- ================================ AUTO FORMAT MARKDOWN TABLES ==========================
--
local function format_markdown_table()
  -- 0. Get buffer, row, and lines
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  -- above, the function nvim_win_get_cursor(0) uses 0 to specify the current window.
  -- the output from nvim_win_get_cursor is a table with  { row, col }
  -- so we use [1] to capture the row number where the cursor is
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- check if we are in a table
  if not lines[row]:match '^%s*|.*|%s*$' then
    return
  end

  -- find table boundaries
  local start_line, end_line = row, row
  -- Move up from start line scanning for table pipes
  while start_line > 1 and lines[start_line - 1]:match '^%s*|.*|%s*$' do
    start_line = start_line - 1
  end
  -- Move down from end_line scanning for table pipes
  while end_line < #lines and lines[end_line + 1]:match '^%s*|.*|%s*$' do
    end_line = end_line + 1
  end
  -- Note: the # is the length operator,
  -- # gives the number of elements in a sequence (as in #lines)
  -- or number of bytes (ie length) of a string (as in #content below)

  -- get all lines from start_line to end_line
  local table_lines = {}
  for i = start_line, end_line do
    table.insert(table_lines, lines[i])
  end

  -- 2. Parse rows, save cell text data, and calculate max width per col
  -- parse and calculate widths
  local parsed_rows = {}
  local col_widths = {}

  -- below, we use ipairs since table_lines is essentially a list
  for r, line in ipairs(table_lines) do
    -- split the row/line into cells based on |
    local cells = vim.split(line:match '^%s*|?(.*)|%s*$', '|') -- note capture group ?()
    -- guarding against nil match if line without | is accidentally parsed
    if cells then
      --local cells = vim.split(line:match '^%s*|?(.*)|%s*$', '|') -- note capture group ?()
      --local cells = match
      local row_data = {}
      -- Preserve text in the row, update col_widths if the new content is longest found
      for i, cell in ipairs(cells) do
        local content = vim.trim(cell) -- get text unpadded
        row_data[i] = content
        -- don*t use row 2 (|---|) dashes to count col width
        if r ~= 2 then
          col_widths[i] = math.max(col_widths[i] or 0, #content)
        end
      end
      table.insert(parsed_rows, row_data)
    end
  end

  -- 3. Reconstruct formatted lines
  local formatted_lines = {}
  for r, row_data in ipairs(parsed_rows) do
    local line_parts = {}
    for c, cell in ipairs(row_data) do
      local width = col_widths[c] or 0
      if r == 2 then -- special handling for separator line
        table.insert(line_parts, string.rep('-', width + 2))
      else
        table.insert(line_parts, ' ' .. cell .. string.rep(' ', width - #cell) .. ' ')
      end
    end
    -- concat the formatted line parts and append to formatted_lines table
    table.insert(formatted_lines, '|' .. table.concat(line_parts, '|') .. '|')
  end

  -- 4. set lines in buffer
  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, formatted_lines)
end

vim.keymap.set('n', '<leader>ct', format_markdown_table, { desc = 'format markdown table' })
---
