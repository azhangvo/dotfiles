return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  keys = {
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>g", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
    { "<leader>s", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>h", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
    { "<leader>S", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep (args/file filter)" },
    {
      "<leader>G",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          default_text = vim.fn.expand("<cword>"),
        })
      end,
      desc = "Grep String (args/file filter)",
    },
    { "<leader>y", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  },
  config = function()
    if vim.fn.executable("rg") == 0 then
      vim.notify(
        "telescope: ripgrep (rg) not found on PATH — grep_string/live_grep/live_grep_args"
          .. " will silently return no results. Install it (e.g. `brew install ripgrep`)."
          .. " Run :checkhealth telescope for the full dependency report.",
        vim.log.levels.WARN
      )
    end

    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- rg skips dotfiles/dotdirs by default, which is most of this repo
        -- (.config/, .gitconfig, .dotfiles/, .tmux.conf) — search hidden
        -- paths but keep .git/ internals out explicitly, since --hidden
        -- overrides rg's usual automatic exclusion of .git/.
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          -- find_files doesn't take vimgrep_arguments; same reasoning as above.
          additional_args = { "--glob=!.git/" },
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "live_grep_args")
  end,
}
