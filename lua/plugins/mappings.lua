---type @LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings={
        n = {
          -- Utils
          ["<Leader><Leader>x"] = {":source %<CR>", desc="Source current file"},
          -- AI 
          ["<Leader>a"] = { desc = "AI" },
          ["<Leader>aa"] = { function()
            vim.cmd("CodeCompanion")
          end,
          desc = "Ask AI Inline"
          },
          ["<Leader>ac"] = {
          function()
          vim.cmd("CodeCompanionChat")
          end,
          desc = "Chat with AI"
          },
          ["<Leader>fml"] = {
            function()
            vim.cmd("CellularAutomaton make_it_rain")
            end,
            desc = "Make it Rain"
          }
        },
        v = {
          ["<Leader>aa"] = { function()
            vim.cmd("'<,'>CodeCompanion")
          end,
          desc = "Ask AI Inline"
          },
        }
      }
   },
  }
}
