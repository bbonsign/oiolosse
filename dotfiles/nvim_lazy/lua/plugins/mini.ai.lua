-- https://www.lazyvim.org/configuration/recipes#change-surround-mappings
return {
  "nvim-mini/mini.ai",
  opts = {
    custom_textobjects = {
      r = require("mini.ai").gen_spec.pair("[", "]"),
      c = require("mini.ai").gen_spec.pair("{", "}"),
    },
  },
}
