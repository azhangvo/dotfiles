return {
  "saghen/blink.cmp",
  -- Latest stable major -- v2 has no tagged release yet.
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- "enter" preset: <CR> accepts the selected item. Default preset
    -- leaves <CR> unbound and <Tab> only does snippet-jumping, so neither
    -- ever accepts -- only Up/Down move the selection, which just previews
    -- without confirming. <Tab>/<S-Tab> added on top to also cycle
    -- selection (falling back to snippet-jump/literal tab when no menu is
    -- open). <CR> overridden to select_and_accept (selects item 1 if
    -- nothing is selected yet, then accepts) rather than the preset's
    -- plain accept, which no-ops with nothing selected now that preselect
    -- is off below.
    keymap = {
      preset = "enter",
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    -- preselect = false: nothing is highlighted until Tab/Down is actually
    -- pressed. With the default (true), item 1 counts as already selected
    -- the moment the menu opens, so the first <Tab> (select_next) skips
    -- straight past it to item 2 instead of landing on item 1.
    completion = {
      list = { selection = { preselect = false } },
    },
    appearance = { nerd_font_variant = "mono" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
  opts_extend = { "sources.default" },
}
