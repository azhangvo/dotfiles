return {
  "nvim-treesitter/nvim-treesitter",
  -- own docs: doesn't support lazy-loading
  lazy = false,
  build = ":TSUpdate",
  config = function()
    if vim.fn.executable("tree-sitter") == 0 then
      vim.notify(
        "nvim-treesitter: tree-sitter-cli not found on PATH — parser installs will fail"
          .. " (falls back to whatever parsers Neovim ships built-in, e.g. lua/vimdoc/c/markdown)."
          .. " Install it (e.g. `brew install tree-sitter`). Run :checkhealth nvim-treesitter"
          .. " for the full dependency report.",
        vim.log.levels.WARN
      )
    end

    require("nvim-treesitter").setup()

    -- main branch dropped ensure_installed/highlight.enable -- install +
    -- enable per-buffer on demand instead.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        if not vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
          return -- no parser exists for this filetype
        end
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        if vim.tbl_contains(require("nvim-treesitter.config").get_installed(), lang) then
          pcall(vim.treesitter.start, ev.buf)
        else
          require("nvim-treesitter").install({ lang }):await(function()
            pcall(vim.treesitter.start, ev.buf)
          end)
        end
      end,
    })
  end,
}
