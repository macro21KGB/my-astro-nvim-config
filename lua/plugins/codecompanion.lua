return {
  {
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
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
      adapters = {
        gemini = function()
          local api_key = os.getenv("OPENROUTER_API_KEY")
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              api_key = api_key,
              url="https://openrouter.ai/api",
              chat_url="/v1/chat/completions"
            },
            schema = {
              model = {
                default = "google/gemini-2.0-flash-001"
              }
            },
          })
        end
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts= {
      mappings = {

        n = {
          ["<Leader>a"] = {desc = "AI"},
          ["<Leader>ac"] = { "<cmd>:CodeCompanionChat<CR>", desc = "CodeCompanion Chat" },
        },

        v = {
          ["<Leader>a"] = {desc = "AI"},
          ["<Leader>aa"] = { "<cmd>'<,'>:CodeCompanion<cr>", desc = "Chat AI inline"}
        }
      }
    },
  },
}
