function PostMessages()
  -- Create a new buffer and set it as the current buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)

  -- Get the messages from the message history
  local messages = vim.api.nvim_exec('messages', true)

  -- Split the messages into lines
  local lines = vim.split(messages, '\n')

  -- Set the lines in the new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

end
