---type @LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings={
        n = {
          -- INFO: Movements
					-- ["s"] = {"<Cmd>HopWord<Cr>", desc = "hop around the file"},
					-- ["S"] = {"<Cmd>HopChar1<Cr>", desc = "Hop around with only one char"},
          -- INFO: Utils
          ["<Leader>fF"] = {":lua MiniFiles.open()<CR>", desc="File Manager using mini.files"},
          ["<Leader>w"] = {":w<CR>:source<CR>", desc="Save and source the file"},
        }
      }
   },
  }
}
