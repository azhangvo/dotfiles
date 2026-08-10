-- Keymaps go here as they're ported over from the existing setup. See BACKLOG.md.

-- LSP navigation. Overrides vim's own classic (pre-LSP, ctags-free) `gd`/`gD`
-- text-search motions -- the LSP versions are strictly more useful once a
-- server is attached, and just no-op harmlessly with no server attached.
-- declaration vs. definition is an LSP-protocol distinction: declaration is
-- where a symbol is announced without a body (e.g. a C header prototype),
-- definition is where the real implementation lives. Many servers (most
-- outside C/C++) don't implement `textDocument/declaration` at all, in which
-- case `gD` is simply a no-op on that server.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
vim.keymap.set("n", "<leader>k", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Big movement: same direction as lowercase hjkl, 5 units at a time instead
-- of 1. Overrides vim's defaults for these (H/L = top/bottom of window, J =
-- join lines, K = hover via LSP-attach default, though the LSP default
-- politely backs off since a custom `K` keymap already exists here).
vim.keymap.set({"n", "v"}, "H", "5h", { desc = "Left 5" })
vim.keymap.set({"n", "v"}, "J", "5j", { desc = "Down 5" })
vim.keymap.set({"n", "v"}, "K", "5k", { desc = "Up 5" })
vim.keymap.set({"n", "v"}, "L", "5l", { desc = "Right 5" })

-- Like `*` (search word under cursor, populate search register + history,
-- enable hlsearch) but without jumping to the next match -- cursor stays put.
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

-- Visual-mode counterpart: same idea, but for an arbitrary selection instead
-- of a whole word -- the classic "visual star search" pattern (search for
-- exactly the selected text), just without the jump. `\V` = very-nomagic, so
-- the selection is matched near-literally; still need to escape `\` (the one
-- character that's still special in \V) and `/` (defensive -- harmless here,
-- but matches the register being safe to reuse at a `/` prompt later).
--
-- Deliberately reads the `v`/`.` marks, not `'<`/`'>`: a Lua callback bound
-- to an x-mode keymap runs *while still in Visual mode* (confirmed via
-- `mode()` still reporting "v" inside the callback) -- `'<`/`'>` are only
-- populated once Visual mode is actually left, so they're empty here. `v`
-- (selection anchor) and `.` (cursor, the other end) are live during an
-- active selection and give the same range.
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
  -- drop back to Normal mode -- cursor stays exactly where the selection
  -- left it, but you're done selecting and n/N are ready to use.
  vim.cmd("normal! \27")
end, { desc = "Search selection (stay in place)" })

-- Jumplist navigation (older/newer jump position -- think browser
-- back/forward, tracks motions like G/gg/search/%/gd, not every cursor
-- move). `<C-o>`/`<C-i>` are vim's real defaults for this; `<Tab>` and
-- `<C-i>` are literally the same byte (ASCII 0x09) in a terminal, so plain
-- Tab already does this on a terminal without an enhanced keyboard protocol
-- (e.g. Terminal.app). Bound explicitly anyway: self-documenting, and it's
-- the only thing that makes Tab correct on a terminal that *can* tell Tab
-- and Ctrl-I apart (Kitty/WezTerm/Ghostty's keyboard protocol).
vim.keymap.set("n", "<Tab>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "<S-Tab>", "<C-o>", { desc = "Jump backward" })
