return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      -- Buffer-local, gitsigns' own idiom -- only in git-tracked buffers.
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        vim.keymap.set("n", "<leader>B", gitsigns.preview_hunk_inline, {
          buffer = bufnr,
          desc = "Show current hunk diff inline",
        })
        vim.keymap.set("n", "<leader>bb", gitsigns.blame_line, {
          buffer = bufnr,
          desc = "Blame current line",
        })
      end,
    })
  end,
}
