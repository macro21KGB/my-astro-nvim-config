local M = {}

function M.git_root()
  local git_dir = vim.fn.finddir('.git', ';')
  if git_dir ~= '' then
    return vim.fn.fnamemodify(git_dir, ':h')
  end
  return nil
end

function M.typst_watch()
  local git_root = M.git_root()
  if git_root then
    vim.cmd('vsp')
    vim.cmd('vertical resize 20')
    vim.cmd('terminal typst watch ' .. vim.fn.expand('%:p'))
    vim.cmd('normal <c-w>h')
  else
    print('Error: Not in a git repository.')
  end
end

function M.typst_view_pdf()
  local pdf_path = vim.fn.expand('%:p:r') .. '.pdf'
  vim.system({'okular', pdf_path}, {
    detach = true,
  })
end


function M.create_section()
  local section_name = vim.fn.input('Section name: ')
  if section_name ~= '' then
    -- Copy the current selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    vim.fn.setreg('z', vim.fn.getline(start_pos[2], end_pos[2]))

    -- Create a new file in the sections/ directory
    local section_path = 'sections/' .. section_name .. '.typ'
    vim.fn.writefile({ vim.fn.getreg('z') }, section_path)
    -- Insert an include statement in the current file
    local include_statement = '#include "' .. section_path .. '"'
    vim.api.nvim_put({ include_statement }, 'l', true, true)

    -- delete the original selection
    vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})
  end
end

function M.download_image(url, save_path)
  vim.system({"curl", "-L", "-o", save_path, url}, {
    detach = true,
  })
end

function M.setup()
  vim.keymap.set('n', '  tc', M.typst_watch, { silent = true, desc = 'Compile Typst document on write' })
  vim.keymap.set('n', '  tr', M.typst_view_pdf, { silent = true, desc = 'View Typst PDF' })
  vim.keymap.set('n', '  td', function()

    local url = vim.fn.input('Image URL: ')
    if url ~= '' then
      local filename = vim.fn.fnamemodify(url, ':t')
      local save_path = 'images/' .. filename
      M.download_image(url, save_path)
      -- Insert an image include statement in the current file
      local include_statement = '#image("' .. save_path .. '")'
      vim.api.nvim_put({ include_statement }, 'l', true, true)
    end

  end,
  { silent = true, desc = 'Download images to images/' })
  vim.keymap.set('v', '  ts', M.create_section, { silent = true, desc = 'Create a new section from selection' })
end

return M


