if vim.fn.has("nvim-0.10") == 0 then
  vim.notify(
    "This config requires Neovim >= 0.10 (oil.nvim's floor, the strictest of any plugin here)."
      .. " Current version is too old — install a newer nvim.",
    vim.log.levels.ERROR
  )
  return
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
