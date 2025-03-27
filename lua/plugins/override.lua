---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    opts= function(_,opts)
     local uname = vim.loop.os_uname()
     local os_name = uname.sysname:lower()
     if os_name == "windows_nt" then
      opts.shell = 'C:/"Program Files"/PowerShell/7/pwsh.exe'
     end
    end
  },
}
