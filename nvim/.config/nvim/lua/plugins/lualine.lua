return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  -- theme left as "auto": lualine has no bundled kanagawa theme file, but
  -- "auto" introspects the active colorscheme's own highlight groups at
  -- runtime rather than needing one -- kanagawa.nvim defines those groups
  -- properly, so this already tracks kanagawa-dragon with no extra config.
  opts = {},
}
