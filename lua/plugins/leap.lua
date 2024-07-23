return {
  {
    "ggandor/leap.nvim",
    name="leap.nvim",
    config=function(_,opts) 
      require("leap").setup(opts)
      require('leap').create_default_mappings()
    end
  }
}
