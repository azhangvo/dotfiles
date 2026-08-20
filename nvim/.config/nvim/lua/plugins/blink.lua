return {
  "saghen/blink.cmp",
  -- Latest stable major -- v2 has no tagged release yet.
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- "enter" preset: <CR> accepts the (pre-selected) top item. Default
    -- preset leaves <CR> unbound and <Tab> only does snippet-jumping, so
    -- neither ever accepts -- only Up/Down move the selection, which just
    -- previews without confirming. <Tab>/<S-Tab> added on top to also cycle
    -- selection (falling back to snippet-jump/literal tab when no menu is
    -- open).
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
  opts_extend = { "sources.default" },
}
