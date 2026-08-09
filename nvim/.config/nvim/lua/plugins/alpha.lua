return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- default theme's buttons assume a different (two-key, grouped) leader
    -- scheme than ours, and two reference features we don't have (frecency,
    -- sessions). Rewire to our actual keymaps/commands.
    -- Important: feed the real <leader>-keymap, not a raw <cmd>...<cr>.
    -- telescope/oil are lazy-loaded on their `keys` triggers; a raw ex
    -- command bypasses that hook entirely, so on a fresh session (this
    -- dashboard is the first thing shown) the command doesn't exist yet.
    -- Feeding the actual keymap goes through lazy.nvim's real
    -- keymap-interception path instead -- confirmed empirically: telescope
    -- was NOT loaded before feeding <leader>f, and WAS loaded after.
    local remap_opts = { remap = true, silent = true, nowait = true }
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find Files", "<leader>f", remap_opts),
      dashboard.button("s", "󰍉  Live Grep", "<leader>s", remap_opts),
      dashboard.button("g", "󰈬  Grep String", "<leader>g", remap_opts),
      dashboard.button("h", "󰊄  Old Files", "<leader>h", remap_opts),
      dashboard.button("o", "󰉋  Open Parent Directory", "<leader>o", remap_opts),
      dashboard.button("e", "  New File", "<cmd>ene<CR>"),
      dashboard.button("q", "󰐥  Quit", "<cmd>qa<cr>"),
    }

    -- default theme has no vertical centering at all — content just sits at
    -- the top, leaving the rest of the window as empty ~ lines. Compute the
    -- top padding dynamically so it centers regardless of window height.
    local content_height = #dashboard.section.header.val -- header art
      + 2 -- static padding between header and buttons
      + (#dashboard.section.buttons.val * 2 - 1) -- buttons + spacing between them
      + 1 -- footer
    local function top_padding()
      return math.max(2, math.floor((vim.fn.winheight(0) - content_height) / 2))
    end
    dashboard.config.layout[1].val = top_padding

    -- ~ marks "no buffer content here", not "unfilled window" — top-only
    -- padding still leaves ~ below since the buffer is still short. Mirror
    -- it with real (empty) bottom padding so actual line count matches
    -- winheight and there's nothing left for ~ to mark.
    table.insert(dashboard.config.layout, {
      type = "padding",
      val = function()
        return math.max(0, vim.fn.winheight(0) - content_height - top_padding())
      end,
    })

    require("alpha").setup(dashboard.config)
  end,
}
