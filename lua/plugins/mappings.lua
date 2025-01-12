---type @LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings={
        n = {
          -- INFO: Movements
					["s"] = {"<Cmd>HopWord<Cr>", desc = "hop around the file"},
					["S"] = {"<Cmd>HopChar1<Cr>", desc = "Hop around with only one char"},
          -- INFO: Utils
          ["<Leader><Leader>x"] = {":source %<CR>", desc="Source current file"},
          ["<Leader><Leader>f"] = {"<Cmd>Oil<CR>", desc="File manager using oil.nvim"},
          -- INFO: AI 
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
