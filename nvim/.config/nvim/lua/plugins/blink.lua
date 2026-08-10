return {
  "saghen/blink.cmp",
  -- Latest stable major -- v2 has no tagged release yet.
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
  opts_extend = { "sources.default" },
}
