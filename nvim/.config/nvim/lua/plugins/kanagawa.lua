return {
  "rebelot/kanagawa.nvim",
  -- Colorschemes need to load before anything else renders.
  lazy = false,
  priority = 1000,
  opts = {
    theme = "dragon",
    background = { dark = "dragon" },
    commentStyle = { italic = false },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
