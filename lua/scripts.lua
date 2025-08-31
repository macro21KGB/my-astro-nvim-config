
local function map(tbl, func)
    local new_tbl = {}
    for k, v in pairs(tbl) do
        new_tbl[k] = func(v)
    end
    return new_tbl
end

print(map)

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

  print("Executing command: " .. curl_cmd)

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

vim.api.nvim_create_user_command("SelectBuffer", function()
  local buffers = {}
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- print(string.format("Buffer %d: %s", bufnr, bufname))
      table.insert(buffers, {bufname=bufname, bufnr=bufnr})
  end

end
  local buffers_names = map(buffers, function(buffer)
    return buffer.bufname
  end)

  local selected = require("mini.pick").start({source={items=buffers_names}})

  vim.api.nvim_command("b " .. selected)

end, {nargs = 0})


vim.keymap.set("n", "<leader>bf", ":SelectBuffer<CR>", {
  desc= "Select buffer to jump"
})

