return {
  "mason-org/mason-lspconfig.nvim",
  -- Wires its own FileType autocmd to auto-enable servers on first buffer,
  -- so it can't be lazy-loaded (same reasoning as alpha/oil).
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  opts = {
    -- No servers pre-selected -- install via `:Mason` or add on request.
    ensure_installed = {},
  },
  config = function(_, opts)
    -- Merge blink.cmp's richer completion capabilities into every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    require("mason-lspconfig").setup(opts)
  end,
}
