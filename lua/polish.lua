-- mini.nvim module configuration
require("mini.ai").setup()
require("mini.files").setup({
  mappings = {
    go_in = "<Tab>",
    go_out = "<Esc>"
  }
})
require("mini.move").setup()
require("mini.operators").setup()
