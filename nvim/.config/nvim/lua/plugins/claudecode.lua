return {
  "coder/claudecode.nvim",
  -- README's example spec depends on folke/snacks.nvim for its "snacks"
  -- terminal provider, but that's `pcall`-guarded in the plugin's own
  -- source (lua/claudecode/terminal/snacks.lua) and only loaded when
  -- provider="snacks" is actually selected -- not a hard requirement.
  -- snacks itself was deliberately dropped from this config (alpha covers
  -- the dashboard use case), so use Neovim's own built-in terminal instead
  -- rather than pulling snacks back in just to satisfy an unused provider.
  opts = {
    terminal = { provider = "native" },
  },
  -- full list of the plugin's own user commands (verified directly from
  -- lua/claudecode/init.lua's nvim_create_user_command calls, not just the
  -- README's example -- that list was actually missing ClaudeCodeSendText).
  -- Same bug class as the earlier alpha dashboard fix: a command absent
  -- from this list can't be lazy-load-triggered, so it just doesn't exist
  -- until something else loads the plugin first.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeSendText",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "oil" },
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  config = function(_, opts)
    if vim.fn.executable("claude") == 0 then
      vim.notify(
        "claudecode: `claude` CLI not found on PATH -- this plugin drives it as a"
          .. " subprocess, nothing will work without it. Install it from"
          .. " https://claude.com/claude-code.",
        vim.log.levels.WARN
      )
    end
    require("claudecode").setup(opts)
  end,
}
