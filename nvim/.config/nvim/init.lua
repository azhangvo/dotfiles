if vim.fn.has("nvim-0.11.3") == 0 then
  vim.notify(
    "This config requires Neovim >= 0.11.3 (nvim-lspconfig's floor, the strictest of any plugin here)."
      .. " Current version is too old — install a newer nvim.",
    vim.log.levels.ERROR
  )
  return
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
