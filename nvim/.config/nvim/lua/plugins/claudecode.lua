return {
  "coder/claudecode.nvim",
  -- README's example needs snacks.nvim for its terminal provider, but
  -- that's optional (pcall-guarded); use nvim's own built-in terminal.
  opts = {
    terminal = { provider = "native" },
  },
  -- Full command list (README's example omits ClaudeCodeSendText) -- a
  -- command missing here can't lazy-load-trigger the plugin.
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
    -- <Cmd> mappings run without changing mode, so this works to close the
    -- pane from inside the Claude terminal too, no need to leave terminal
    -- mode first (:help <Cmd>).
    { "<C-e>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Toggle Claude" },
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
        "claudecode: `claude` CLI not found on PATH -- install from https://claude.com/claude-code.",
        vim.log.levels.WARN
      )
    end
    require("claudecode").setup(opts)
  end,
}
