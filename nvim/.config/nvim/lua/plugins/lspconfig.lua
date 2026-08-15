return {
  "mason-org/mason-lspconfig.nvim",
  -- Wires its own FileType autocmd to auto-enable servers on first buffer,
  -- so it can't be lazy-loaded (same reasoning as alpha/oil).
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  opts = {
    -- No servers pre-selected -- install via `:Mason` or add on request.
    ensure_installed = {},
  },
  config = function(_, opts)
    -- Merge blink.cmp's richer completion capabilities into every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    require("mason-lspconfig").setup(opts)

    -- ensure_installed stays empty by design (see above) -- but a filetype
    -- with no LSP client and no installed server for it is easy to miss
    -- silently. Nudge once per filetype per session via Mason's own
    -- filetype->package map, rather than installing anything automatically.
    local notified = {}
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        vim.defer_fn(function()
          if not vim.api.nvim_buf_is_valid(args.buf) then
            return
          end
          if #vim.lsp.get_clients({ bufnr = args.buf }) > 0 then
            return
          end
          local ft = vim.bo[args.buf].filetype
          if ft == "" or notified[ft] then
            return
          end
          local ok_mappings, mappings = pcall(require, "mason-lspconfig.mappings")
          local ok_registry, registry = pcall(require, "mason-registry")
          if not (ok_mappings and ok_registry) then
            return
          end
          local servers = mappings.get_filetype_map()[ft]
          if not servers then
            return
          end
          local lspconfig_to_package = mappings.get_mason_map().lspconfig_to_package
          local seen, missing = {}, {}
          for _, server in ipairs(servers) do
            local pkg = lspconfig_to_package[server]
            if pkg and not seen[pkg] and registry.has_package(pkg) and not registry.is_installed(pkg) then
              seen[pkg] = true
              table.insert(missing, pkg)
            end
          end
          if #missing > 0 then
            notified[ft] = true
            -- Mason's filetype map covers every LSP-protocol tool for a
            -- filetype (formatters, linters, security scanners included),
            -- which balloons for popular languages -- cap what's shown and
            -- point at :Mason's own filter UI for the rest.
            local shown = { unpack(missing, 1, 6) }
            local suffix = #missing > 6 and (" (+%d more, see :Mason)"):format(#missing - 6) or ""
            vim.notify(
              ("No LSP client for '%s'. Install with: :MasonInstall %s%s"):format(ft, table.concat(shown, " "), suffix),
              vim.log.levels.WARN
            )
          end
        end, 1500)
      end,
    })
  end,
}
