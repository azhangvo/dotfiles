return {
  "rebelot/kanagawa.nvim",
  -- colorscheme plugins need to load and apply before anything else renders,
  -- so lazy-loading (the default for every other plugin here) is wrong here.
  lazy = false,
  priority = 1000,
  opts = {
    theme = "dragon",
    background = { dark = "dragon" },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
