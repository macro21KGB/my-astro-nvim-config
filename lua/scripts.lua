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

