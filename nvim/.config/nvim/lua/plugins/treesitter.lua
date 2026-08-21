-- Which nvim-treesitter branch/config to use is machine-dependent, so it's
-- picked here at load time instead of by hand-swapping files -- lets the
-- same repo work unmodified across machines with different nvim versions
-- and different ability to install tree-sitter-cli:
--   * "main" (current branch) needs tree-sitter-cli for EVERY parser
--     (both `tree-sitter generate` and `tree-sitter build`) and dropped
--     support for Neovim < 0.12's config API.
--   * "master" (frozen upstream, "backward compatibility only") only
--     needs tree-sitter-cli for parsers that ship grammar-only source;
--     most common languages (bash, lua, python, json, yaml, markdown, ...)
--     ship a pre-generated parser.c that master compiles directly with a
--     system C compiler (cc/gcc/clang/zig), no CLI involved. But
--     upstream's own README states Neovim 0.12 is NOT supported (0.10/0.11
--     only) -- verified against upstream, not assumed.
--
-- So: 0.12+ always gets main, since master won't load there regardless of
-- CLI availability. On 0.11.x, master is preferred when tree-sitter-cli is
-- missing (checked via `executable()`), since it still gets most languages
-- highlighted with nothing but a C compiler.
local has_cli = vim.fn.executable("tree-sitter") == 1
local nvim_supports_master = vim.fn.has("nvim-0.12") == 0
local use_master = nvim_supports_master and not has_cli

if use_master then
  return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    -- master's own docs: doesn't support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.notify(
        "nvim-treesitter: tree-sitter-cli not found, using the frozen `master` branch"
          .. " (pre-generated parsers compiled with a system C compiler only)."
          .. " Install tree-sitter-cli (e.g. `brew install tree-sitter`) for full parser"
          .. " coverage on the current `main` branch instead.",
        vim.log.levels.WARN
      )
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "python", "markdown", "markdown_inline" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  }
end

return {
  "nvim-treesitter/nvim-treesitter",
  -- own docs: doesn't support lazy-loading
  lazy = false,
  build = ":TSUpdate",
  config = function()
    if not has_cli then
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
