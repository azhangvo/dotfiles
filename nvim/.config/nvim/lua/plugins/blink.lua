return {
  "saghen/blink.cmp",
  -- pinned to the latest stable major -- v2 only exists on the unreleased
  -- `main` branch as of writing, no tagged release yet.
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
  opts_extend = { "sources.default" },
}
