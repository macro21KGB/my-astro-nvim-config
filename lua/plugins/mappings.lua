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
					["f"] = { function()
            local directions = require('hop.hint').HintDirection
  			    require("hop").hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
					end,
					},
					["F"] = { function()
            local directions = require('hop.hint').HintDirection
  			    require("hop").hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
            end
					},
          -- INFO: Utils
          ["<Leader>fF"] = {":lua MiniFiles.open()<CR>", desc="File Manager using mini.files"},
          ["<Leader>ff"] = {" :lua MiniPick.builtin.files({tool = 'rg'})<CR>", desc="Telescope-like mini pick"},
          ["<Leader>w"] = {":w<CR>:source<CR>", desc="Save and source the file"},
        }
      }
   },
  }
}
