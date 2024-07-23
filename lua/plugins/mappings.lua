---type @LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings={
        n = {
          ["<Leader><Leader>x"] = {":source %", desc="Source current file"},
        }

      }
   },
  }
}
