return {
  "stevearc/oil.nvim",
  -- oil's own docs: lazy-loading is not recommended, tricky to get right.
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    { "<leader>o", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {},
}
