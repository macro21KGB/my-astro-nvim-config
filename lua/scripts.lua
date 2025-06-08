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
  vim.cmd('4TermExec cmd="aider --editor-model openrouter/google/gemini-2.0-flash-001 --architect --model openrouter/qwen/qwq-32b:free --no-auto-lint --watch-files" size=50 dir=' .. current_folder .. ' direction=vertical')
end

function M.obsidian_create_toc()
    local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft ~= 'markdown' then
    vim.notify("Current buffer is not a markdown file", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local toc = {}
  local toc_string = ""

  for i, line in ipairs(lines) do
    local heading_level = string.match(line, "^(#+)")
    if heading_level then
      local level = string.len(heading_level)
      local heading_text = string.sub(line, level + 2)
      local link = heading_text:gsub("%s", "-"):lower()
      table.insert(toc, { level = level, text = heading_text, link = link })
    end
  end

  if #toc > 0 then
    toc_string = "## Table of Contents\n"
    for _, heading in ipairs(toc) do
      local indent = string.rep("  ", heading.level - 1)
      toc_string = toc_string .. indent .. "* [[#" .. heading.text .. "]]\n"
    end
    toc_string = toc_string .. "\n"
    -- Insert the TOC at the cursor position
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_set_lines(buf, current_line, current_line, false, vim.split(toc_string, "\n"))
    vim.notify("Table of Contents created")
  else
    vim.notify("No headings found in the current buffer", vim.log.levels.WARN)
  end
end

-- Function to convert SRT to TXT
function M.srt_to_txt()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft ~= 'srt' then
    vim.notify("Current buffer is not an SRT file", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local txt_lines = {}

  for _, line in ipairs(lines) do
    -- Skip lines that are numbers or timestamps
    if not line:match("^%d+$") and not line:match("^%d%d:%d%d:%d%d") then
      table.insert(txt_lines, line)
    end
  end

  -- Set the converted lines back to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, txt_lines)
  vim.notify("SRT converted to TXT")
end
-- Create a user command for easier access
  vim.api.nvim_create_user_command('ObsidianConvert', function()
    M.obsidian_convert()
  end, {})

  vim.api.nvim_create_user_command('OpenAider', function()
    M.open_aider()
  end, {})

  vim.api.nvim_create_user_command('ObsidianCreateToc', function()
    M.obsidian_create_toc()
  end, {})

  vim.api.nvim_create_user_command('SrtToTxt', function()
    M.srt_to_txt()
  end, {})

  vim.api.nvim_create_user_command('RaylibRun', function()
    M.run_raylib()
  end, {})

function M.run_raylib()
  -- Execute the command silently and capture output
  local status, output = pcall(vim.fn.system, "make run")

  if not status then
    vim.notify("Error running 'make run': " .. tostring(output), vim.log.levels.ERROR)
    return
  end

  local buf = nil
  local raylib_buf_name = '[raylib output]'

  -- Check if a buffer with the name [raylib output] already exists
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == raylib_buf_name then
      buf = b
      -- Clear existing content
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
      break
    end
  end

  -- If no existing buffer found, create a new one
  if buf == nil then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_name(buf, raylib_buf_name)
  end

  -- Set the output to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))

  -- Find or create a window for the buffer
  local win = nil
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(w) == buf then
      win = w
      break
    end
  end

  if win == nil then
    vim.cmd('split')
    win = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_win_set_buf(win, buf);
  vim.api.nvim_win_set_option(win, 'wrap', false);

  vim.notify("Raylib app executed. Output in [raylib output] buffer.", vim.log.levels.INFO)
end


vim.keymap.set("n", "<Leader>r", "" ,{desc="Raylib Utils"})
vim.keymap.set("n", "<Leader>rr", function()
  M.run_raylib()
end, {desc = "Run raylib with make and show output"})

return M
