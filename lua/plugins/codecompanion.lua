return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = true,
  ---@type AstroCoreOpts
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
    adapters = {
      anthropic = function()
        local api_key = os.getenv("ANTHROPIC_API_KEY")
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = api_key
          },
          schema = {
            model = {
              default = "claude-3-haiku-20240307"
            }
          },
        })
      end
    },
  },
}
