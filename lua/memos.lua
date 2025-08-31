local M = {}
function GetSelection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  local selected_content = ""

  if start_line == end_line then
    selected_content = vim.fn.getline(start_line):sub(start_col, end_col)
  else
    selected_content = vim.fn.getline(start_line):sub(start_col) .. "\n"
    for i = start_line + 1, end_line - 1 do
      selected_content = selected_content .. vim.fn.getline(i) .. "\n"
    end
    selected_content = selected_content .. vim.fn.getline(end_line):sub(1, end_col)
  end

  local payload = {
    content = selected_content,
    file_name = vim.fn.expand("%:t")
  }

  SendHttpRequest("POST", "https://n8n.mariodeluca.com/webhook/d33a6348-2d78-4e1b-b58e-7a6e76804c7b", {
    ["Content-Type"]="application/json"
  },
    vim.json.encode(payload))

  vim.notify("Snippet added to memos")

end



function M.setup(opts) 
  vim.api.nvim_set_keymap("x", "<leader>m", "", {desc="Memos", noremap = true})
  vim.api.nvim_set_keymap("x", "<leader>ma", ":lua GetSelection()<CR>", {noremap = true, silent= true, desc="Add snippet to memos"})
end

return M
