---type @LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings={
        n = {
          -- INFO: Utils
          ["<Leader>fF"] = {":lua MiniFiles.open()<CR>", desc="File Manager using mini.files"},
          ["<Leader>w"] = {":w<CR>:source<CR>", desc="Save and source the file"},
        }
      }
   },
  }
}
