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
          return require("codecompanion.adapters").extend("openrouter", {
            schema = {
              model = {
                default = "google/gemini-3.5-flash-lite"
              },
              provider = {
                default = {
                  allow_fallbacks = true,
                  order = { "anthropic", "openai" },
                  require_parameters = false,
                },
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
