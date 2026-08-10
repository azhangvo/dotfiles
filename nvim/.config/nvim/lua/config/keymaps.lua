-- Keymaps go here as they're ported over from the existing setup. See BACKLOG.md.

-- LSP nav/format. `gd`/`gD`/`gr` override vim's classic pre-LSP text-search
-- motions; declaration = symbol announced without a body (e.g. a C header
-- prototype), definition = the real implementation -- most servers outside
-- C/C++ don't implement declaration, so `gD` no-ops there.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
vim.keymap.set("n", "<leader>k", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })
-- Core's default hover bind (`K`) backs off since `K` is remapped below.
vim.keymap.set("n", "<leader>t", vim.lsp.buf.hover, { desc = "Hover (tooltip)" })

-- Big movement: hjkl direction, 5 units at a time.
vim.keymap.set({ "n", "v" }, "H", "5h", { desc = "Left 5" })
vim.keymap.set({ "n", "v" }, "J", "5j", { desc = "Down 5" })
vim.keymap.set({ "n", "v" }, "K", "5k", { desc = "Up 5" })
vim.keymap.set({ "n", "v" }, "L", "5l", { desc = "Right 5" })

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
