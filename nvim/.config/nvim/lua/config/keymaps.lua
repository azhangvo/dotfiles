-- Keymaps go here as they're ported over from the existing setup. See BACKLOG.md.

-- LSP nav/format. `gd`/`gD`/`gr` override vim's classic pre-LSP text-search
-- motions; declaration = symbol announced without a body (e.g. a C header
-- prototype), definition = the real implementation -- most servers outside
-- C/C++ don't implement declaration, so `gD` no-ops there.
-- `gd`/`gr` routed through Telescope's LSP pickers rather than
-- vim.lsp.buf.* directly -- their default handler is nvim's plain
-- quickfix-list UI; this repo uses Telescope for every other picker
-- (find_files/live_grep/workspace_symbols, see plugins/telescope.lua), so
-- this keeps LSP nav consistent with that. `gD` stays on vim.lsp.buf --
-- telescope.builtin has no lsp_declarations picker to route it through.
-- require() deferred into the callback since telescope.nvim is lazy-loaded
-- (see plugins/telescope.lua's `keys` triggers) -- these binds may run
-- before it's loaded otherwise.
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Goto References" })
vim.keymap.set("n", "gt", function()
  require("telescope.builtin").lsp_type_definitions()
end, { desc = "Goto Type Definition" })
vim.keymap.set("n", "gi", function()
  require("telescope.builtin").lsp_implementations()
end, { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>k", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })
-- Core's default hover bind (`K`) backs off since `K` is remapped below.
vim.keymap.set("n", "<leader>t", vim.lsp.buf.hover, { desc = "Hover (tooltip)" })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Diagnostics, scoped by how much of the workspace to look at: l(ine) is
-- the cursor's own diagnostics as a floating popup; f(ile)/p(roject) route
-- through Telescope, same rationale as the gd/gr/gt/gi pickers above.
vim.diagnostic.config({ float = { border = "rounded" } })
vim.keymap.set("n", "<leader>el", function()
  vim.diagnostic.open_float()
end, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>ef", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "File diagnostics" })
vim.keymap.set("n", "<leader>ep", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Project diagnostics" })

-- Reference-copying macros (see config/refs.lua). g/G mirror each other
-- (commit-pinned vs branch-pinned GitHub link) and always use a default
-- remote with no prompt; r/R are the same pair but always show the
-- Telescope remote picker, even with only one candidate. l is the
-- no-GitHub local fallback. Visual variants read the selection before the
-- trailing Esc drops back to Normal mode -- same pattern as gs above.
vim.keymap.set("n", "<leader>pg", function()
  require("config.refs").github_link("commit", false)
end, { desc = "Copy GitHub link (commit, default remote)" })
vim.keymap.set("x", "<leader>pg", function()
  require("config.refs").github_link("commit", false)
  vim.cmd("normal! \27")
end, { desc = "Copy GitHub link (commit, default remote)" })
vim.keymap.set("n", "<leader>pG", function()
  require("config.refs").github_link("branch", false)
end, { desc = "Copy GitHub link (branch, default remote)" })
vim.keymap.set("x", "<leader>pG", function()
  require("config.refs").github_link("branch", false)
  vim.cmd("normal! \27")
end, { desc = "Copy GitHub link (branch, default remote)" })
vim.keymap.set("n", "<leader>pr", function()
  require("config.refs").github_link("commit", true)
end, { desc = "Copy GitHub link (commit, pick remote)" })
vim.keymap.set("x", "<leader>pr", function()
  require("config.refs").github_link("commit", true)
  vim.cmd("normal! \27")
end, { desc = "Copy GitHub link (commit, pick remote)" })
vim.keymap.set("n", "<leader>pR", function()
  require("config.refs").github_link("branch", true)
end, { desc = "Copy GitHub link (branch, pick remote)" })
vim.keymap.set("x", "<leader>pR", function()
  require("config.refs").github_link("branch", true)
  vim.cmd("normal! \27")
end, { desc = "Copy GitHub link (branch, pick remote)" })
vim.keymap.set("n", "<leader>pl", function()
  require("config.refs").local_link()
end, { desc = "Copy local file:line ref" })
vim.keymap.set("x", "<leader>pl", function()
  require("config.refs").local_link()
  vim.cmd("normal! \27")
end, { desc = "Copy local file:line ref" })
vim.keymap.set("n", "<leader>pi", function()
  require("config.refs").python_import_path()
end, { desc = "Copy Python import path" })

-- H/L: start/end of the *visual* (display) line -- g0/g$ rather than 0/$,
-- so on a wrapped line they land at the wrap boundary under the cursor
-- instead of jumping to the true start/end of the logical line.
vim.keymap.set({ "n", "v" }, "H", "g0", { desc = "Start of visual line" })
vim.keymap.set({ "n", "v" }, "L", "g$", { desc = "End of visual line" })

-- J/K: 5 *display* lines at a time (g-prefixed motions), so a wrapped line
-- counts as several stops instead of collapsing to one jump per logical
-- line.
vim.keymap.set({ "n", "v" }, "J", "5gj", { desc = "Down 5 (visual lines)" })
vim.keymap.set({ "n", "v" }, "K", "5gk", { desc = "Up 5 (visual lines)" })

-- Plain j/k get the same display-line fix. The v:count check keeps numeric
-- counts working as logical-line jumps (e.g. 12j) -- gj/gk with a count
-- moves that many *display* lines instead, which isn't what a typed count
-- means here.
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (visual line aware)" })
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (visual line aware)" })

-- Like `*` but without jumping -- just sets the search register/hlsearch.
local function apply_search(pattern)
  vim.fn.setreg("/", pattern)
  vim.fn.histadd("search", pattern)
  vim.o.hlsearch = true
end

vim.keymap.set("n", "gs", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end
  apply_search("\\<" .. word .. "\\>")
end, { desc = "Search word under cursor (stay in place)" })

-- Visual counterpart ("visual star search" without the jump). Reads the
-- `v`/`.` marks, not `'<`/`'>` -- those aren't populated until Visual mode
-- is actually left, and this callback runs while still in it.
vim.keymap.set("x", "gs", function()
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local start_pos, end_pos = anchor, cursor
  if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
    start_pos, end_pos = end_pos, start_pos
  end
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines == 0 then
    return
  end
  if #lines == 1 then
    lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
  else
    lines[1] = lines[1]:sub(start_pos[3])
    lines[#lines] = lines[#lines]:sub(1, end_pos[3])
  end
  local text = table.concat(lines, "\n")
  if text == "" then
    return
  end
  local escaped = vim.fn.escape(text, "\\/"):gsub("\n", "\\n")
  apply_search("\\V" .. escaped)
  vim.cmd("normal! \27")
end, { desc = "Search selection (stay in place)" })

-- Jumplist navigation (`<C-o>`/`<C-i>` are vim's own defaults for this).
vim.keymap.set("n", "<Tab>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "<S-Tab>", "<C-o>", { desc = "Jump backward" })
