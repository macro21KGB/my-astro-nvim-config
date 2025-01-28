function ObsidianConvert()
  -- Get the current buffer
  local buf = vim.api.nvim_get_current_buf()
  -- Get all lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  -- Process each line
  for i, line in ipairs(lines) do
    -- Replace \( with $ and \) with $
    line = line:gsub("\\%(", "$")
    line = line:gsub("\\%)", "$")
    lines[i] = line
  end
  -- Set the modified lines back to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end
