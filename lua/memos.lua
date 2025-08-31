local M = {}

local BASE_URL = os.getenv("MEMOS_N8N_URL") or ""

---@param method string The method of the request
---@param url string The url to send the request
function SendHttpRequest(method, url, headers, body)
  -- Start building the curl command
  local curl_cmd = "curl -s -X " .. method .. " "

  -- Add headers
  if headers then
    for key, value in pairs(headers) do
      curl_cmd = curl_cmd .. "-H '" .. key .. ": " .. value .. "' "
    end
  end

  -- Add request body for non-GET methods
  if body and (method == "POST" or method == "PUT" or method == "PATCH") then
    -- Escape single quotes in the body for shell command
    local escaped_body = body:gsub("'", "'\\''")
    curl_cmd = curl_cmd .. "--data '" .. escaped_body .. "' "
  end

  -- Add the URL
  curl_cmd = curl_cmd .. vim.fn.shellescape(url) -- Properly escape the URL

  -- Execute the curl command and capture its output
  local success, result = pcall(vim.fn.system, curl_cmd)

  if success then
    -- 'result' will contain the stdout of the curl command
    return result
  else
    -- 'result' will contain the error message from pcall
    error("Failed to execute curl: " .. result)
  end
end

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

  SendHttpRequest("POST", BASE_URL, {
    ["Content-Type"]="application/json"
  },
    vim.json.encode(payload))

  vim.notify("Snippet added to memos")

end

function GetSnippetMemos()

  local result = SendHttpRequest("GET", BASE_URL, {
    ["Content-Type"]="application/json"
  })

  local json_obj = vim.json.decode(result)

  local items = {}
  for _, v in pairs(json_obj) do
    table.insert(items, {
      text= v.title,
      preview = v.content
    })
    end

   require("mini.pick").start({source={items=items,
    choose= function(item)
      vim.fn.setreg('+', item.preview)
      vim.notify("Snippet saved to Register")
      return false

    end,
    preview=function(buf_id, item)
      vim.api.nvim_set_option_value("filetype", "markdown", {
        buf = buf_id
      })
      local lines = vim.split(item.preview, '\n')
      vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    end
  }})
end


function M.setup(opts)
  vim.api.nvim_set_keymap("x", "<leader>m", "", {desc="Memos", noremap = true})
  vim.api.nvim_set_keymap("n", "<leader>m", "", {desc="Memos", noremap = true})

  vim.api.nvim_set_keymap("n", "<leader>mg", ":lua GetSnippetMemos()<CR>", {noremap = true, silent= true, desc="Get snippets"})
  vim.api.nvim_set_keymap("x", "<leader>ma", ":lua GetSelection()<CR>", {noremap = true, silent= true, desc="Add snippet to memos"})
end

return M
