return {
  "olimorris/codecompanion.nvim",
  opts = {
    prompt_library = {
      markdown = {
        dirs = {
          "/home/mario/.config/nvim/prompts",
        },
      }
    },
    strategies = {
      chat = {
        adapter = "openrouter_gemini"
      },
      inline = {
        adapter = "openrouter_gemini"
      },
      cmd = {
        adapter = "openrouter_gemini"
      },
    },
    adapters = {
      http = {
        openrouter_gemini = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "google/gemini-2.5-flash",
              },
            },
          })
        end
      }
      }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
