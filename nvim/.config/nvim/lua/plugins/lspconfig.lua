return {
  "mason-org/mason-lspconfig.nvim",
  -- mason-lspconfig wires its own FileType-based autocmd to auto-enable
  -- installed servers on the first buffer -- same class of startup-timing
  -- issue as alpha/oil earlier in this config, so it can't be lazy-loaded.
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  opts = {
    -- no servers pre-selected -- install via `:Mason` or add a language
    -- here on request, matching the barebones-first philosophy elsewhere
    -- in this config (see nvim-treesitter's per-buffer install instead of
    -- a fixed ensure_installed list).
    ensure_installed = {},
  },
  config = function(_, opts)
    -- blink.cmp advertises richer completion capabilities than Neovim's
    -- defaults; every server needs them merged in to actually return
    -- LSP-sourced completions, so wire it once for '*' rather than per
    -- server. vim.lsp.config/vim.lsp.enable are Neovim's own native LSP
    -- config API (0.11+) -- nvim-lspconfig no longer needs a per-server
    -- require('lspconfig').SERVER.setup{} call, it just ships default
    -- configs that this merges with.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    require("mason-lspconfig").setup(opts)
  end,
}
