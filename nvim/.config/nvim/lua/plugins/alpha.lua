return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- Feed real <leader>-keymaps, not raw ex commands -- telescope/oil are
    -- lazy-loaded on their `keys` triggers, which a raw command bypasses.
    local remap_opts = { remap = true, silent = true, nowait = true }
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find Files", "<leader>f", remap_opts),
      dashboard.button("s", "󰍉  Live Grep", "<leader>s", remap_opts),
      dashboard.button("g", "󰈬  Grep String", "<leader>g", remap_opts),
      dashboard.button("h", "󰊄  Old Files", "<leader>h", remap_opts),
      dashboard.button("o", "󰉋  Open Parent Directory", "<leader>o", remap_opts),
      dashboard.button("e", "󰈔  New File", "<cmd>ene<CR>"),
      dashboard.button("q", "󰐥  Quit", "<cmd>qa<cr>"),
    }

    -- Default theme has no vertical centering -- compute padding dynamically.
    local content_height = #dashboard.section.header.val
      + 2
      + (#dashboard.section.buttons.val * 2 - 1)
      + 1
    local function top_padding()
      return math.max(2, math.floor((vim.fn.winheight(0) - content_height) / 2))
    end
    dashboard.config.layout[1].val = top_padding

    -- Real bottom padding too, so line count matches winheight (no stray ~).
    table.insert(dashboard.config.layout, {
      type = "padding",
      val = function()
        return math.max(0, vim.fn.winheight(0) - content_height - top_padding())
      end,
    })

    require("alpha").setup(dashboard.config)
  end,
}
