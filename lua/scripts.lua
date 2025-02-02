local M = {}

-- Function to convert Obsidian math notation
function M.obsidian_convert()
  local status, err = pcall(function()
    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()
    -- Check if current buffer is a markdown file
    local ft = vim.bo[buf].filetype
    if ft ~= 'markdown' then
      vim.notify("Current buffer is not a markdown file", vim.log.levels.WARN)
      return
    end
    -- Get all lines from the buffer
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    -- Process each line
    for i, line in ipairs(lines) do
      -- Replace \( with $ and \) with $
      line = line:gsub("\\%(", "$")
      line = line:gsub("\\%)", "$")
      line = line:gsub("\\%]", "$$")
      line = line:gsub("\\%[", "$$")
      lines[i] = line
    end
    -- Set the modified lines back to the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Latex converted to Markdown")
  end)

  if not status then
    vim.notify("Error in obsidian_convert: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.open_aider()
  local current_folder = vim.fn.getcwd()
  vim.cmd('4TermExec cmd="aider --deepseek --watch-files" size=50 dir=' .. current_folder .. ' direction=vertical')
end

-- Create a user command for easier access
vim.api.nvim_create_user_command('ObsidianConvert', function()
  M.obsidian_convert()
end, {})

vim.api.nvim_create_user_command('OpenAider', function()
  M.open_aider()
end, {})
return M
