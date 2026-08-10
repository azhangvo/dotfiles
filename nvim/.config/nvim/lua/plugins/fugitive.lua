return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gclog", "Gllog" },
  keys = {
    -- `:{range}Gclog` uses `git log -L` to load commits+diffs touching that
    -- line range into the quickfix list; `:0Gclog` targets the whole file.
    { "<leader>bh", "<cmd>.Gclog<cr>", desc = "Commit history + diffs for this line" },
    { "<leader>bh", ":Gclog<cr>", mode = "x", desc = "Commit history + diffs for selection" },
    { "<leader>bH", "<cmd>0Gclog<cr>", desc = "Commit history + diffs for file" },
  },
}
